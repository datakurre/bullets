module View.HelpDialog exposing (view)

{-| Help dialog view for keyboard shortcuts

@docs view

-}

import Html exposing (Html, button, div, h2, h3, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import I18n


{-| View the help dialog overlay with keyboard shortcuts
-}
view : I18n.Translations -> msg -> Html msg
view t closeMsg =
    div [ class "help-overlay", onClick closeMsg ]
        [ div [ class "help-dialog" ]
            [ div [ class "help-header" ]
                [ h2 [] [ text t.keyboardShortcuts ]
                , button [ class "help-close", onClick closeMsg ] [ text "×" ]
                ]
            , div [ class "help-content" ]
                [ div [ class "help-section" ]
                    [ h3 [] [ text t.navigation ]
                    , viewShortcut "↑ / k" t.previousSlide
                    , viewShortcut "↓ / j" t.nextSlide
                    , viewShortcut "g" t.firstSlide
                    , viewShortcut "G" t.lastSlide
                    ]
                , div [ class "help-section" ]
                    [ h3 [] [ text t.slideManagement ]
                    , viewShortcut "Ctrl+Shift+↑" t.reorderSlideUp
                    , viewShortcut "Ctrl+Shift+↓" t.reorderSlideDown
                    ]
                , div [ class "help-section" ]
                    [ h3 [] [ text t.fileOperations ]
                    , viewShortcut "Ctrl+I" t.uploadImageFile
                    , viewShortcut "Ctrl+O" t.importFile
                    , viewShortcut "Ctrl+S" t.exportFile
                    ]
                , div [ class "help-section" ]
                    [ h3 [] [ text t.enterPresentation ]
                    , viewShortcut "p" t.enterPresentation
                    , viewShortcut "ESC" t.exitPresentation
                    , viewShortcut "Space / Enter / →" (t.nextSlide ++ " (" ++ t.enterPresentation ++ ")")
                    , viewShortcut "← / h" (t.previousSlide ++ " (" ++ t.enterPresentation ++ ")")
                    , viewShortcut "l" (t.nextSlide ++ " (" ++ t.enterPresentation ++ ")")
                    ]
                , div [ class "help-section" ]
                    [ h3 [] [ text t.other ]
                    , viewShortcut "?" t.showHelp
                    , viewShortcut "ESC" t.close
                    ]
                ]
            ]
        ]


{-| View a single keyboard shortcut entry
-}
viewShortcut : String -> String -> Html msg
viewShortcut keys description =
    div [ class "help-shortcut" ]
        [ span [ class "help-keys" ] [ text keys ]
        , span [ class "help-description" ] [ text description ]
        ]
