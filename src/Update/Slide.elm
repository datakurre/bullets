module Update.Slide exposing
    ( addSlide
    , addSlideAfter
    , deleteSlide
    , dragEnd
    , dragOver
    , dragStart
    , drop
    , duplicateSlide
    , moveSlideDown
    , moveSlideUp
    )

{-| Update handlers for slide operations.

This module handles adding, deleting, duplicating, and reordering slides.

-}

import I18n
import Json as AppJson
import Json.Encode as Encode
import Ports
import SlideManipulation
import Types exposing (Model, Msg, Presentation)


{-| Save presentation to local storage.
-}
savePresentation : Presentation -> Cmd Msg
savePresentation presentation =
    let
        json =
            AppJson.encodePresentation presentation

        jsonString =
            Encode.encode 0 json
    in
    Ports.saveToLocalStorage jsonString


{-| Add a new slide at the end of the presentation.
-}
addSlide : Model -> ( Model, Cmd Msg )
addSlide model =
    let
        t =
            I18n.translations model.language

        presentation =
            model.presentation

        updatedSlides =
            SlideManipulation.addSlide presentation.slides

        updatedPresentation =
            { presentation | slides = updatedSlides }

        newIndex =
            List.length updatedSlides - 1

        newSlide =
            List.drop newIndex updatedSlides
                |> List.head
    in
    ( { model
        | presentation = updatedPresentation
        , currentSlideIndex = newIndex
        , editingContent = Maybe.map .content newSlide |> Maybe.withDefault "# New Slide"
        , announcement = t.slideAdded
      }
    , savePresentation updatedPresentation
    )


{-| Add a new slide after the specified index.
-}
addSlideAfter : Int -> Model -> ( Model, Cmd Msg )
addSlideAfter index model =
    let
        t =
            I18n.translations model.language

        presentation =
            model.presentation

        updatedSlides =
            SlideManipulation.addSlideAfter index presentation.slides

        updatedPresentation =
            { presentation | slides = updatedSlides }

        newIndex =
            index + 1

        newSlide =
            List.drop newIndex updatedSlides
                |> List.head
    in
    ( { model
        | presentation = updatedPresentation
        , currentSlideIndex = newIndex
        , editingContent = Maybe.map .content newSlide |> Maybe.withDefault "# New Slide"
        , announcement = t.slideAdded
      }
    , savePresentation updatedPresentation
    )


{-| Delete slide at the specified index. Prevents deleting the last slide.
-}
deleteSlide : Int -> Model -> ( Model, Cmd Msg )
deleteSlide index model =
    let
        t =
            I18n.translations model.language

        presentation =
            model.presentation

        updatedSlides =
            SlideManipulation.deleteSlide index presentation.slides

        updatedPresentation =
            { presentation | slides = updatedSlides }

        newIndex =
            min (List.length updatedSlides - 1) model.currentSlideIndex
                |> max 0
    in
    if List.length presentation.slides <= 1 then
        ( model, Cmd.none )

    else
        ( { model
            | presentation = updatedPresentation
            , currentSlideIndex = newIndex
            , announcement = t.slideDeleted
          }
        , savePresentation updatedPresentation
        )


{-| Duplicate slide at the specified index.
-}
duplicateSlide : Int -> Model -> ( Model, Cmd Msg )
duplicateSlide index model =
    let
        t =
            I18n.translations model.language

        presentation =
            model.presentation

        updatedSlides =
            SlideManipulation.duplicateSlide index presentation.slides

        updatedPresentation =
            { presentation | slides = updatedSlides }
    in
    ( { model
        | presentation = updatedPresentation
        , announcement = t.slideDuplicated
      }
    , savePresentation updatedPresentation
    )


{-| Move slide up one position. Does nothing if already at top.
-}
moveSlideUp : Int -> Model -> ( Model, Cmd Msg )
moveSlideUp index model =
    if index <= 0 then
        ( model, Cmd.none )

    else
        let
            t =
                I18n.translations model.language

            presentation =
                model.presentation

            updatedSlides =
                SlideManipulation.moveSlideUp index presentation.slides

            updatedPresentation =
                { presentation | slides = updatedSlides }

            newIndex =
                if model.currentSlideIndex == index then
                    index - 1

                else if model.currentSlideIndex == index - 1 then
                    index

                else
                    model.currentSlideIndex
        in
        ( { model
            | presentation = updatedPresentation
            , currentSlideIndex = newIndex
            , announcement = t.slideMovedUp
          }
        , savePresentation updatedPresentation
        )


{-| Move slide down one position. Does nothing if already at bottom.
-}
moveSlideDown : Int -> Model -> ( Model, Cmd Msg )
moveSlideDown index model =
    let
        t =
            I18n.translations model.language

        presentation =
            model.presentation

        maxIndex =
            List.length presentation.slides - 1
    in
    if index >= maxIndex then
        ( model, Cmd.none )

    else
        let
            updatedSlides =
                SlideManipulation.moveSlideDown index presentation.slides

            updatedPresentation =
                { presentation | slides = updatedSlides }

            newIndex =
                if model.currentSlideIndex == index then
                    index + 1

                else if model.currentSlideIndex == index + 1 then
                    index

                else
                    model.currentSlideIndex
        in
        ( { model
            | presentation = updatedPresentation
            , currentSlideIndex = newIndex
            , announcement = t.slideMovedDown
          }
        , savePresentation updatedPresentation
        )


{-| Start dragging a slide.
-}
dragStart : Int -> Model -> ( Model, Cmd Msg )
dragStart index model =
    ( { model | draggedSlideIndex = Just index }, Cmd.none )


{-| Update drop target during drag.
-}
dragOver : Int -> Model -> ( Model, Cmd Msg )
dragOver targetIndex model =
    ( { model | dropTargetIndex = Just targetIndex }, Cmd.none )


{-| End drag operation without dropping.
-}
dragEnd : Model -> ( Model, Cmd Msg )
dragEnd model =
    ( { model | draggedSlideIndex = Nothing, dropTargetIndex = Nothing }, Cmd.none )


{-| Drop dragged slide at target index.
-}
drop : Int -> Model -> ( Model, Cmd Msg )
drop targetIndex model =
    case model.draggedSlideIndex of
        Just sourceIndex ->
            if sourceIndex == targetIndex then
                ( { model | draggedSlideIndex = Nothing, dropTargetIndex = Nothing }, Cmd.none )

            else
                let
                    presentation =
                        model.presentation

                    updatedSlides =
                        SlideManipulation.moveSlide sourceIndex targetIndex presentation.slides

                    updatedPresentation =
                        { presentation | slides = updatedSlides }

                    -- Calculate new current slide index
                    newCurrentIndex =
                        if model.currentSlideIndex == sourceIndex then
                            targetIndex

                        else if sourceIndex < model.currentSlideIndex && targetIndex >= model.currentSlideIndex then
                            model.currentSlideIndex - 1

                        else if sourceIndex > model.currentSlideIndex && targetIndex <= model.currentSlideIndex then
                            model.currentSlideIndex + 1

                        else
                            model.currentSlideIndex
                in
                ( { model
                    | presentation = updatedPresentation
                    , currentSlideIndex = newCurrentIndex
                    , draggedSlideIndex = Nothing
                    , dropTargetIndex = Nothing
                  }
                , savePresentation updatedPresentation
                )

        Nothing ->
            ( { model | draggedSlideIndex = Nothing, dropTargetIndex = Nothing }, Cmd.none )
