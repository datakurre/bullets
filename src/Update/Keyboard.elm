module Update.Keyboard exposing (keyPressed)

{-| Update handlers for keyboard input.

This module handles complex keyboard shortcut logic including VIM-style keybindings,
modifier keys, and context-aware behavior.

-}

import I18n
import Types exposing (Mode(..), Model, Msg(..))
import Update.FileIO
import Update.Image
import Update.Mode
import Update.Navigation
import Update.Slide
import Update.UI


{-| Handle keyboard input in presentation mode.
-}
handlePresentModeKey : String -> Model -> ( Model, Cmd Msg )
handlePresentModeKey key model =
    case key of
        "ArrowRight" ->
            Update.Navigation.nextSlide model

        " " ->
            Update.Navigation.nextSlide model

        "Enter" ->
            Update.Navigation.nextSlide model

        "ArrowLeft" ->
            Update.Navigation.prevSlide model

        -- VIM keybindings for presentation mode
        "j" ->
            Update.Navigation.nextSlide model

        "k" ->
            Update.Navigation.prevSlide model

        "h" ->
            Update.Navigation.prevSlide model

        "l" ->
            Update.Navigation.nextSlide model

        "g" ->
            Update.Navigation.goToSlide 0 model

        "G" ->
            let
                lastIndex =
                    List.length model.presentation.slides - 1
            in
            Update.Navigation.goToSlide lastIndex model

        _ ->
            ( model, Cmd.none )


{-| Handle keyboard input in edit mode (when textarea not focused).
-}
handleEditModeKey : String -> Model -> ( Model, Cmd Msg )
handleEditModeKey key model =
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
                Update.Navigation.goToSlide newIndex model

            "k" ->
                let
                    newIndex =
                        max 0 (model.currentSlideIndex - 1)
                in
                Update.Navigation.goToSlide newIndex model

            "p" ->
                Update.Mode.enterPresentMode model

            "g" ->
                Update.Navigation.goToSlide 0 model

            "G" ->
                let
                    lastIndex =
                        List.length model.presentation.slides - 1
                in
                Update.Navigation.goToSlide lastIndex model

            _ ->
                ( model, Cmd.none )


{-| Handle all keyboard events with modifier keys and context.
-}
keyPressed : String -> Bool -> Bool -> Model -> ( Model, Cmd Msg )
keyPressed key ctrlKey shiftKey model =
    let
        t =
            I18n.translations model.language
    in
    case key of
        -- Help dialog toggle (works in both modes)
        "?" ->
            Update.UI.toggleHelpDialog model

        "Escape" ->
            -- ESC closes help dialog if open, otherwise normal behavior
            if model.showHelpDialog then
                Update.UI.toggleHelpDialog model

            else
                case model.mode of
                    Present ->
                        Update.Mode.exitPresentMode model

                    Edit ->
                        ( model, Cmd.none )

        "ArrowUp" ->
            -- Ctrl+Shift+Up moves current slide up in edit mode
            if model.mode == Edit && ctrlKey && shiftKey && not model.isTextareaFocused then
                let
                    ( updatedModel, cmd ) =
                        Update.Slide.moveSlideUp model.currentSlideIndex model
                in
                ( { updatedModel | announcement = t.slideMovedUp }, cmd )

            else if model.mode == Edit && not model.isTextareaFocused then
                -- Regular arrow up navigation
                let
                    newIndex =
                        max 0 (model.currentSlideIndex - 1)
                in
                Update.Navigation.goToSlide newIndex model

            else
                ( model, Cmd.none )

        "ArrowDown" ->
            -- Ctrl+Shift+Down moves current slide down in edit mode
            if model.mode == Edit && ctrlKey && shiftKey && not model.isTextareaFocused then
                let
                    ( updatedModel, cmd ) =
                        Update.Slide.moveSlideDown model.currentSlideIndex model
                in
                ( { updatedModel | announcement = t.slideMovedDown }, cmd )

            else if model.mode == Edit && not model.isTextareaFocused then
                -- Regular arrow down navigation
                let
                    maxIndex =
                        List.length model.presentation.slides - 1

                    newIndex =
                        min maxIndex (model.currentSlideIndex + 1)
                in
                Update.Navigation.goToSlide newIndex model

            else
                ( model, Cmd.none )

        "i" ->
            -- Ctrl+I for image upload in edit mode
            if model.mode == Edit && ctrlKey && not model.isTextareaFocused then
                Update.Image.imageUploadRequested model

            else
                ( model, Cmd.none )

        "o" ->
            -- Ctrl+O for PPTX import in edit mode
            if model.mode == Edit && ctrlKey && not model.isTextareaFocused then
                Update.FileIO.importPPTXRequested model

            else
                ( model, Cmd.none )

        _ ->
            -- Don't handle other keys if help dialog is shown
            if model.showHelpDialog then
                ( model, Cmd.none )

            else
                case model.mode of
                    Present ->
                        handlePresentModeKey key model

                    Edit ->
                        handleEditModeKey key model
