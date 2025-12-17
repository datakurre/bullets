module Update.UITest exposing (suite)

import Expect
import I18n exposing (Language(..))
import Test exposing (Test, describe, test)
import Types exposing (initialModel)
import Update.UI


suite : Test
suite =
    describe "Update.UI"
        [ describe "toggleHelpDialog"
            [ describe "given the help dialog is hidden"
                [ describe "when toggling the help dialog"
                    [ test "should show the help dialog" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | showHelpDialog = False }

                                ( newModel, _ ) =
                                    Update.UI.toggleHelpDialog model
                            in
                            Expect.equal True newModel.showHelpDialog
                    ]
                ]
            , describe "given the help dialog is visible"
                [ describe "when toggling the help dialog"
                    [ test "should hide the help dialog" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | showHelpDialog = True }

                                ( newModel, _ ) =
                                    Update.UI.toggleHelpDialog model
                            in
                            Expect.equal False newModel.showHelpDialog
                    ]
                ]
            ]
        , describe "textareaFocused"
            [ describe "when the textarea receives focus"
                [ test "should set isTextareaFocused to true" <|
                    \_ ->
                        let
                            model =
                                { initialModel | isTextareaFocused = False }

                            ( newModel, _ ) =
                                Update.UI.textareaFocused model
                        in
                        Expect.equal True newModel.isTextareaFocused
                ]
            ]
        , describe "textareaBlurred"
            [ describe "when the textarea loses focus"
                [ test "should set isTextareaFocused to false" <|
                    \_ ->
                        let
                            model =
                                { initialModel | isTextareaFocused = True }

                            ( newModel, _ ) =
                                Update.UI.textareaBlurred model
                        in
                        Expect.equal False newModel.isTextareaFocused
                ]
            ]
        , describe "changeLanguage"
            [ describe "given the current language is English"
                [ describe "when changing to Finnish"
                    [ test "should update the language to Finnish" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | language = English }

                                ( newModel, _ ) =
                                    Update.UI.changeLanguage Finnish model
                            in
                            Expect.equal Finnish newModel.language
                    ]
                ]
            , describe "given the current language is Finnish"
                [ describe "when changing to English"
                    [ test "should update the language to English" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | language = Finnish }

                                ( newModel, _ ) =
                                    Update.UI.changeLanguage English model
                            in
                            Expect.equal English newModel.language
                    ]
                ]
            ]
        , describe "languageLoaded"
            [ describe "when loading language preference from storage"
                [ describe "given valid Finnish preference"
                    [ test "should set language to Finnish" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | language = English }

                                jsonString =
                                    "\"fi\""

                                ( newModel, _ ) =
                                    Update.UI.languageLoaded jsonString model
                            in
                            Expect.equal Finnish newModel.language
                    ]
                , describe "given valid English preference"
                    [ test "should set language to English" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | language = Finnish }

                                jsonString =
                                    "\"en\""

                                ( newModel, _ ) =
                                    Update.UI.languageLoaded jsonString model
                            in
                            Expect.equal English newModel.language
                    ]
                , describe "given invalid JSON"
                    [ test "should keep the current language" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | language = English }

                                ( newModel, _ ) =
                                    Update.UI.languageLoaded "invalid" model
                            in
                            Expect.equal English newModel.language
                    ]
                ]
            ]
        ]
