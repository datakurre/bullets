module Main exposing (main)

import Browser
import Browser.Events
import File
import File.Download as Download
import File.Select as Select
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Json as AppJson
import Json.Decode as Decode
import Json.Encode as Encode
import Navigation
import Ports
import SlideManipulation
import Task
import Types exposing (Mode(..), Model, Msg(..), Presentation, initialModel)
import View.Edit exposing (viewEditMode)
import View.Present exposing (viewPresentMode)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel
    , Cmd.batch
        [ Ports.setupImagePaste ()
        , Ports.loadFromLocalStorage ()
        ]
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NextSlide ->
            let
                totalSlides =
                    List.length model.presentation.slides

                newIndex =
                    Navigation.nextSlide model.currentSlideIndex totalSlides
            in
            ( { model | currentSlideIndex = newIndex }, Cmd.none )

        PrevSlide ->
            let
                newIndex =
                    Navigation.prevSlide model.currentSlideIndex
            in
            ( { model | currentSlideIndex = newIndex }, Cmd.none )

        GoToSlide index ->
            ( { model | currentSlideIndex = Navigation.goToSlide index }, Cmd.none )

        EnterPresentMode ->
            ( { model | mode = Present }, Cmd.none )

        ExitPresentMode ->
            ( { model | mode = Edit }, Cmd.none )

        AddSlide ->
            let
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
              }
            , savePresentation updatedPresentation
            )

        DeleteSlide index ->
            let
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
                  }
                , savePresentation updatedPresentation
                )

        DuplicateSlide index ->
            let
                presentation =
                    model.presentation

                updatedSlides =
                    SlideManipulation.duplicateSlide index presentation.slides

                updatedPresentation =
                    { presentation | slides = updatedSlides }
            in
            ( { model | presentation = updatedPresentation }, savePresentation updatedPresentation )

        MoveSlideUp index ->
            if index <= 0 then
                ( model, Cmd.none )

            else
                let
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
                  }
                , savePresentation updatedPresentation
                )

        MoveSlideDown index ->
            let
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
                  }
                , savePresentation updatedPresentation
                )

        UpdateContent content ->
            let
                presentation =
                    model.presentation

                updatedSlides =
                    List.indexedMap
                        (\i slide ->
                            if i == model.currentSlideIndex then
                                { slide | content = content }

                            else
                                slide
                        )
                        presentation.slides

                updatedPresentation =
                    { presentation | slides = updatedSlides }
            in
            ( { model
                | editingContent = content
                , presentation = updatedPresentation
              }
            , savePresentation updatedPresentation
            )

        ChangeLayout layout ->
            let
                presentation =
                    model.presentation

                updatedSlides =
                    List.indexedMap
                        (\i slide ->
                            if i == model.currentSlideIndex then
                                { slide | layout = layout }

                            else
                                slide
                        )
                        presentation.slides

                updatedPresentation =
                    { presentation | slides = updatedSlides }
            in
            ( { model | presentation = updatedPresentation }, savePresentation updatedPresentation )

        ImagePasted dataUri ->
            let
                presentation =
                    model.presentation

                updatedSlides =
                    List.indexedMap
                        (\i slide ->
                            if i == model.currentSlideIndex then
                                { slide | image = Just dataUri }

                            else
                                slide
                        )
                        presentation.slides

                updatedPresentation =
                    { presentation | slides = updatedSlides }
            in
            ( { model | presentation = updatedPresentation }, savePresentation updatedPresentation )

        RemoveImage ->
            let
                presentation =
                    model.presentation

                updatedSlides =
                    List.indexedMap
                        (\i slide ->
                            if i == model.currentSlideIndex then
                                { slide | image = Nothing }

                            else
                                slide
                        )
                        presentation.slides

                updatedPresentation =
                    { presentation | slides = updatedSlides }
            in
            ( { model | presentation = updatedPresentation }, savePresentation updatedPresentation )

        ImageUploadRequested ->
            ( model, Select.file [ "image/png", "image/jpeg", "image/gif", "image/webp" ] ImageFileSelected )

        ImageFileSelected file ->
            ( model, Task.perform ImageFileLoaded (File.toUrl file) )

        ImageFileLoaded dataUri ->
            let
                presentation =
                    model.presentation

                updatedSlides =
                    List.indexedMap
                        (\i slide ->
                            if i == model.currentSlideIndex then
                                { slide | image = Just dataUri }

                            else
                                slide
                        )
                        presentation.slides

                updatedPresentation =
                    { presentation | slides = updatedSlides }
            in
            ( { model | presentation = updatedPresentation }, savePresentation updatedPresentation )

        DownloadJSON ->
            let
                json =
                    AppJson.encodePresentation model.presentation

                jsonString =
                    Encode.encode 2 json

                filename =
                    model.presentation.title ++ ".json"
            in
            ( model, Download.string filename "application/json" jsonString )

        LoadJSONRequested ->
            ( model, Select.file [ "application/json" ] FileSelected )

        FileSelected file ->
            ( model, Task.perform FileLoaded (File.toString file) )

        FileLoaded content ->
            case Decode.decodeString AppJson.decodePresentation content of
                Ok presentation ->
                    let
                        firstSlideContent =
                            List.head presentation.slides
                                |> Maybe.map .content
                                |> Maybe.withDefault ""
                    in
                    ( { model
                        | presentation = presentation
                        , currentSlideIndex = 0
                        , editingContent = firstSlideContent
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( model, Cmd.none )

        KeyPressed key ->
            case model.mode of
                Present ->
                    case key of
                        "ArrowRight" ->
                            update NextSlide model

                        " " ->
                            update NextSlide model

                        "Enter" ->
                            update NextSlide model

                        "ArrowLeft" ->
                            update PrevSlide model

                        "Escape" ->
                            update ExitPresentMode model

                        -- VIM keybindings for presentation mode
                        "j" ->
                            update NextSlide model

                        "k" ->
                            update PrevSlide model

                        "h" ->
                            update PrevSlide model

                        "l" ->
                            update NextSlide model

                        "g" ->
                            update (GoToSlide 0) model

                        "G" ->
                            let
                                lastIndex =
                                    List.length model.presentation.slides - 1
                            in
                            update (GoToSlide lastIndex) model

                        _ ->
                            ( model, Cmd.none )

                Edit ->
                    -- VIM keybindings for edit mode (when not in textarea)
                    -- Ignore keyboard shortcuts if textarea is focused
                    if model.isTextareaFocused then
                        ( model, Cmd.none )

                    else
                        case key of
                            "j" ->
                                let
                                    maxIndex =
                                        List.length model.presentation.slides - 1

                                    newIndex =
                                        min maxIndex (model.currentSlideIndex + 1)
                                in
                                update (GoToSlide newIndex) model

                            "k" ->
                                let
                                    newIndex =
                                        max 0 (model.currentSlideIndex - 1)
                                in
                                update (GoToSlide newIndex) model

                            "ArrowDown" ->
                                let
                                    maxIndex =
                                        List.length model.presentation.slides - 1

                                    newIndex =
                                        min maxIndex (model.currentSlideIndex + 1)
                                in
                                update (GoToSlide newIndex) model

                            "ArrowUp" ->
                                let
                                    newIndex =
                                        max 0 (model.currentSlideIndex - 1)
                                in
                                update (GoToSlide newIndex) model

                            "p" ->
                                update EnterPresentMode model

                            "g" ->
                                update (GoToSlide 0) model

                            "G" ->
                                let
                                    lastIndex =
                                        List.length model.presentation.slides - 1
                                in
                                update (GoToSlide lastIndex) model

                            _ ->
                                ( model, Cmd.none )

        DragStart index ->
            ( { model | draggedSlideIndex = Just index }, Cmd.none )

        DragOver ->
            ( model, Cmd.none )

        DragEnd ->
            ( { model | draggedSlideIndex = Nothing }, Cmd.none )

        Drop targetIndex ->
            case model.draggedSlideIndex of
                Just sourceIndex ->
                    if sourceIndex == targetIndex then
                        ( { model | draggedSlideIndex = Nothing }, Cmd.none )

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
                          }
                        , savePresentation updatedPresentation
                        )

                Nothing ->
                    ( { model | draggedSlideIndex = Nothing }, Cmd.none )

        LocalStorageLoaded content ->
            if String.isEmpty content then
                ( model, Cmd.none )

            else
                case Decode.decodeString AppJson.decodePresentation content of
                    Ok presentation ->
                        let
                            firstSlideContent =
                                List.head presentation.slides
                                    |> Maybe.map .content
                                    |> Maybe.withDefault ""
                        in
                        ( { model
                            | presentation = presentation
                            , currentSlideIndex = 0
                            , editingContent = firstSlideContent
                          }
                        , Cmd.none
                        )

                    Err _ ->
                        ( model, Cmd.none )

        TextareaFocused ->
            ( { model | isTextareaFocused = True }, Cmd.none )

        TextareaBlurred ->
            ( { model | isTextareaFocused = False }, Cmd.none )

        ExportToPPTX ->
            let
                json =
                    AppJson.encodePresentation model.presentation
            in
            ( model, Ports.exportToPPTX json )

        ImportPPTXRequested ->
            ( model, Ports.importPPTXRequested () )

        PPTXImported jsonString ->
            case Decode.decodeString AppJson.decodePresentation jsonString of
                Ok presentation ->
                    let
                        newModel =
                            { model
                                | presentation = presentation
                                , currentSlideIndex = 0
                                , editingContent =
                                    List.head presentation.slides
                                        |> Maybe.map .content
                                        |> Maybe.withDefault ""
                            }
                    in
                    ( newModel, savePresentation presentation )

                Err _ ->
                    -- If decode fails, it might be an error message
                    ( model, Cmd.none )


savePresentation : Presentation -> Cmd Msg
savePresentation presentation =
    let
        json =
            AppJson.encodePresentation presentation

        jsonString =
            Encode.encode 0 json
    in
    Ports.saveToLocalStorage jsonString



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Browser.Events.onKeyDown keyDecoder
        , Ports.imagePasted ImagePasted
        , Ports.localStorageLoaded LocalStorageLoaded
        , Ports.pptxImported PPTXImported
        ]


keyDecoder : Decode.Decoder Msg
keyDecoder =
    Decode.map KeyPressed (Decode.field "key" Decode.string)



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ case model.mode of
            Edit ->
                viewEditMode model

            Present ->
                viewPresentMode model
        ]
