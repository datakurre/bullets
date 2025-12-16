module Update.UI exposing (changeLanguage, languageLoaded, textareaBlurred, textareaFocused, toggleHelpDialog)

{-| Update handlers for UI state.

This module handles UI state changes like help dialog, language, and textarea focus.

-}

import I18n exposing (Language)
import Json.Decode as Decode
import Json.Encode as Encode
import Ports
import Types exposing (Model, Msg)


{-| Toggle the help dialog open/closed.
-}
toggleHelpDialog : Model -> ( Model, Cmd Msg )
toggleHelpDialog model =
    ( { model | showHelpDialog = not model.showHelpDialog }, Cmd.none )


{-| Mark textarea as focused (disables keyboard shortcuts).
-}
textareaFocused : Model -> ( Model, Cmd Msg )
textareaFocused model =
    ( { model | isTextareaFocused = True }, Cmd.none )


{-| Mark textarea as blurred (enables keyboard shortcuts).
-}
textareaBlurred : Model -> ( Model, Cmd Msg )
textareaBlurred model =
    ( { model | isTextareaFocused = False }, Cmd.none )


{-| Change the user interface language.
-}
changeLanguage : Language -> Model -> ( Model, Cmd Msg )
changeLanguage language model =
    let
        json =
            I18n.encodeLanguage language

        jsonString =
            Encode.encode 0 json
    in
    ( { model | language = language }, Ports.saveLanguagePreference jsonString )


{-| Load language preference from local storage.
-}
languageLoaded : String -> Model -> ( Model, Cmd Msg )
languageLoaded jsonString model =
    case Decode.decodeString I18n.decodeLanguage jsonString of
        Ok language ->
            ( { model | language = language }, Cmd.none )

        Err _ ->
            ( model, Cmd.none )
