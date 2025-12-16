module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class, href)
import I18n
import Json.Decode as Decode
import Ports
import Types exposing (Mode(..), Model, Msg(..), initialModel)
import Update
import View.Edit exposing (viewEditMode)
import View.HelpDialog
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
        , Ports.loadLanguagePreference ()
        ]
    )



-- UPDATE


{-| Main update function - delegates to Update module.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update =
    Update.update



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Browser.Events.onKeyDown keyDecoder
        , Ports.imagePasted ImagePasted
        , Ports.localStorageLoaded LocalStorageLoaded
        , Ports.pptxImported PPTXImported
        , Ports.languageLoaded LanguageLoaded
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
    let
        t =
            I18n.translations model.language
    in
    div [ class "app" ]
        [ viewSkipLink t
        , case model.mode of
            Edit ->
                viewEditMode model

            Present ->
                viewPresentMode model
        , if model.showHelpDialog then
            View.HelpDialog.view t ToggleHelpDialog

          else
            text ""
        , viewLiveRegion model.announcement
        ]


viewSkipLink : I18n.Translations -> Html msg
viewSkipLink t =
    a [ class "skip-link", href "#main-content" ] [ text t.skipToContent ]


viewLiveRegion : String -> Html msg
viewLiveRegion announcement =
    div
        [ class "sr-only"
        , Html.Attributes.attribute "aria-live" "polite"
        , Html.Attributes.attribute "aria-atomic" "true"
        ]
        [ text announcement ]
