module Update.StorageTest exposing (suite)

import Expect
import Test exposing (Test, describe, test)
import Types exposing (Slide, initialModel)
import Update.Storage


suite : Test
suite =
    describe "Update.Storage"
        [ describe "localStorageLoaded"
            [ test "ignores empty content" <|
                \_ ->
                    let
                        model =
                            initialModel

                        ( newModel, _ ) =
                            Update.Storage.localStorageLoaded "" model
                    in
                    Expect.equal model newModel
            , test "loads valid presentation JSON" <|
                \_ ->
                    let
                        model =
                            initialModel

                        json =
                            """{"title":"Loaded Title","author":"Test Author","created":"2025-01-01","slides":[{"content":"# Loaded","image":null}]}"""

                        ( newModel, _ ) =
                            Update.Storage.localStorageLoaded json model
                    in
                    Expect.equal "Loaded Title" newModel.presentation.title
            , test "sets currentSlideIndex to 0" <|
                \_ ->
                    let
                        model =
                            { initialModel | currentSlideIndex = 5 }

                        json =
                            """{"title":"Test","author":"Test","created":"2025-01-01","slides":[{"content":"# Test","image":null}]}"""

                        ( newModel, _ ) =
                            Update.Storage.localStorageLoaded json model
                    in
                    Expect.equal 0 newModel.currentSlideIndex
            , test "sets editingContent from first slide" <|
                \_ ->
                    let
                        model =
                            initialModel

                        json =
                            """{"title":"Test","author":"Test","created":"2025-01-01","slides":[{"content":"# First Slide","image":null}]}"""

                        ( newModel, _ ) =
                            Update.Storage.localStorageLoaded json model
                    in
                    Expect.equal "# First Slide" newModel.editingContent
            , test "ignores invalid JSON" <|
                \_ ->
                    let
                        model =
                            initialModel

                        invalidJson =
                            "not valid json"

                        ( newModel, _ ) =
                            Update.Storage.localStorageLoaded invalidJson model
                    in
                    Expect.equal model newModel
            ]
        ]
