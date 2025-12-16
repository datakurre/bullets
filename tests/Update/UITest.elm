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
            [ test "toggles from false to true" <|
                \_ ->
                    let
                        model =
                            { initialModel | showHelpDialog = False }

                        ( newModel, _ ) =
                            Update.UI.toggleHelpDialog model
                    in
                    Expect.equal True newModel.showHelpDialog
            , test "toggles from true to false" <|
                \_ ->
                    let
                        model =
                            { initialModel | showHelpDialog = True }

                        ( newModel, _ ) =
                            Update.UI.toggleHelpDialog model
                    in
                    Expect.equal False newModel.showHelpDialog
            ]
        , describe "textareaFocused"
            [ test "sets isTextareaFocused to True" <|
                \_ ->
                    let
                        model =
                            { initialModel | isTextareaFocused = False }

                        ( newModel, _ ) =
                            Update.UI.textareaFocused model
                    in
                    Expect.equal True newModel.isTextareaFocused
            ]
        , describe "textareaBlurred"
            [ test "sets isTextareaFocused to False" <|
                \_ ->
                    let
                        model =
                            { initialModel | isTextareaFocused = True }

                        ( newModel, _ ) =
                            Update.UI.textareaBlurred model
                    in
                    Expect.equal False newModel.isTextareaFocused
            ]
        , describe "changeLanguage"
            [ test "changes language from English to Finnish" <|
                \_ ->
                    let
                        model =
                            { initialModel | language = English }

                        ( newModel, _ ) =
                            Update.UI.changeLanguage Finnish model
                    in
                    Expect.equal Finnish newModel.language
            , test "changes language from Finnish to English" <|
                \_ ->
                    let
                        model =
                            { initialModel | language = Finnish }

                        ( newModel, _ ) =
                            Update.UI.changeLanguage English model
                    in
                    Expect.equal English newModel.language
            ]
        , describe "languageLoaded"
            [ test "loads Finnish language preference" <|
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
            , test "loads English language preference" <|
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
            , test "ignores invalid JSON" <|
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
