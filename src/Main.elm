module Main exposing (main)

import Browser
import Browser.Events
import File
import File.Download as Download
import File.Select as Select
import Html exposing (Html, button, div, h2, h3, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (custom, onClick)
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
            ( { model
                | currentSlideIndex = newIndex
                , announcement = "Slide " ++ String.fromInt (newIndex + 1) ++ " of " ++ String.fromInt totalSlides
              }
            , Cmd.none
            )

        PrevSlide ->
            let
                totalSlides =
                    List.length model.presentation.slides

                newIndex =
                    Navigation.prevSlide model.currentSlideIndex
            in
            ( { model
                | currentSlideIndex = newIndex
                , announcement = "Slide " ++ String.fromInt (newIndex + 1) ++ " of " ++ String.fromInt totalSlides
              }
            , Cmd.none
            )

        GoToSlide index ->
            let
                totalSlides =
                    List.length model.presentation.slides
            in
            ( { model
                | currentSlideIndex = Navigation.goToSlide index
                , announcement = "Slide " ++ String.fromInt (index + 1) ++ " of " ++ String.fromInt totalSlides
              }
            , Cmd.none
            )

        EnterPresentMode ->
            ( { model
                | mode = Present
                , announcement = "Entering presentation mode"
              }
            , Cmd.none
            )

        ExitPresentMode ->
            ( { model
                | mode = Edit
                , announcement = "Exiting presentation mode"
              }
            , Cmd.none
            )

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
                , announcement = "Slide added"
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
                    , announcement = "Slide deleted"
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
            ( { model
                | presentation = updatedPresentation
                , announcement = "Slide duplicated"
              }
            , savePresentation updatedPresentation
            )

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
                    , announcement = "Slide moved up"
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
                    , announcement = "Slide moved down"
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

        KeyPressed key ctrlKey shiftKey ->
            case key of
                -- Help dialog toggle (works in both modes, but only when help is not shown)
                "?" ->
                    update ToggleHelpDialog model

                "Escape" ->
                    -- ESC closes help dialog if open, otherwise normal behavior
                    if model.showHelpDialog then
                        update ToggleHelpDialog model

                    else
                        case model.mode of
                            Present ->
                                update ExitPresentMode model

                            Edit ->
                                ( model, Cmd.none )

                "ArrowUp" ->
                    -- Ctrl+Shift+Up moves current slide up in edit mode
                    if model.mode == Edit && ctrlKey && shiftKey && not model.isTextareaFocused then
                        let
                            updatedModel =
                                Tuple.first (update (MoveSlideUp model.currentSlideIndex) model)
                        in
                        ( { updatedModel | announcement = "Slide moved up" }, Cmd.none )

                    else if model.mode == Edit && not model.isTextareaFocused then
                        -- Regular arrow up navigation
                        let
                            newIndex =
                                max 0 (model.currentSlideIndex - 1)
                        in
                        update (GoToSlide newIndex) model

                    else
                        ( model, Cmd.none )

                "ArrowDown" ->
                    -- Ctrl+Shift+Down moves current slide down in edit mode
                    if model.mode == Edit && ctrlKey && shiftKey && not model.isTextareaFocused then
                        let
                            updatedModel =
                                Tuple.first (update (MoveSlideDown model.currentSlideIndex) model)
                        in
                        ( { updatedModel | announcement = "Slide moved down" }, Cmd.none )

                    else if model.mode == Edit && not model.isTextareaFocused then
                        -- Regular arrow down navigation
                        let
                            maxIndex =
                                List.length model.presentation.slides - 1

                            newIndex =
                                min maxIndex (model.currentSlideIndex + 1)
                        in
                        update (GoToSlide newIndex) model

                    else
                        ( model, Cmd.none )

                _ ->
                    -- Don't handle other keys if help dialog is shown
                    if model.showHelpDialog then
                        ( model, Cmd.none )

                    else
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

        DragOver targetIndex ->
            ( { model | dropTargetIndex = Just targetIndex }, Cmd.none )

        DragEnd ->
            ( { model | draggedSlideIndex = Nothing, dropTargetIndex = Nothing }, Cmd.none )

        Drop targetIndex ->
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
                    ( model, Cmd.none )

        ToggleHelpDialog ->
            ( { model | showHelpDialog = not model.showHelpDialog }, Cmd.none )


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
    Decode.map3 KeyPressed
        (Decode.field "key" Decode.string)
        (Decode.field "ctrlKey" Decode.bool)
        (Decode.field "shiftKey" Decode.bool)



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ case model.mode of
            Edit ->
                viewEditMode model

            Present ->
                viewPresentMode model
        , if model.showHelpDialog then
            viewHelpDialog

          else
            text ""
        , viewLiveRegion model.announcement
        ]


viewLiveRegion : String -> Html msg
viewLiveRegion announcement =
    div
        [ class "sr-only"
        , Html.Attributes.attribute "aria-live" "polite"
        , Html.Attributes.attribute "aria-atomic" "true"
        ]
        [ text announcement ]


viewHelpDialog : Html Msg
viewHelpDialog =
    div [ class "help-overlay", onClick ToggleHelpDialog ]
        [ div [ class "help-dialog" ]
            [ div [ class "help-header" ]
                [ h2 [] [ text "Keyboard Shortcuts" ]
                , button [ class "help-close", onClick ToggleHelpDialog ] [ text "×" ]
                ]
            , div [ class "help-content" ]
                [ div [ class "help-section" ]
                    [ h3 [] [ text "Navigation" ]
                    , viewShortcut "↑ / k" "Previous slide"
                    , viewShortcut "↓ / j" "Next slide"
                    , viewShortcut "g" "First slide"
                    , viewShortcut "G" "Last slide"
                    ]
                , div [ class "help-section" ]
                    [ h3 [] [ text "Slide Management" ]
                    , viewShortcut "Ctrl+Shift+↑" "Move current slide up"
                    , viewShortcut "Ctrl+Shift+↓" "Move current slide down"
                    ]
                , div [ class "help-section" ]
                    [ h3 [] [ text "Presentation Mode" ]
                    , viewShortcut "p" "Enter presentation mode"
                    , viewShortcut "ESC" "Exit presentation mode"
                    , viewShortcut "Space / Enter / →" "Next slide (in present mode)"
                    , viewShortcut "← / h" "Previous slide (in present mode)"
                    , viewShortcut "l" "Next slide (in present mode)"
                    ]
                , div [ class "help-section" ]
                    [ h3 [] [ text "Help" ]
                    , viewShortcut "?" "Toggle this help dialog"
                    , viewShortcut "ESC" "Close this help dialog"
                    ]
                ]
            ]
        ]


viewShortcut : String -> String -> Html msg
viewShortcut keys description =
    div [ class "help-shortcut" ]
        [ span [ class "help-keys" ] [ text keys ]
        , span [ class "help-description" ] [ text description ]
        ]
