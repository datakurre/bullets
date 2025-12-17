module Update.StorageTest exposing (suite)

import Expect
import Test exposing (Test, describe, test)
import Types exposing (initialModel)
import Update.Storage


suite : Test
suite =
    describe "Update.Storage"
        [ describe "localStorageLoaded"
            [ describe "given empty content"
                [ describe "when loading from local storage"
                    [ test "should not modify the model" <|
                        \_ ->
                            let
                                model =
                                    initialModel

                                ( newModel, _ ) =
                                    Update.Storage.localStorageLoaded "" model
                            in
                            Expect.equal model newModel
                    ]
                ]
            , describe "given valid presentation JSON"
                [ describe "when loading from local storage"
                    [ test "should load the presentation data" <|
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
                    , test "should reset currentSlideIndex to the first slide" <|
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
                    , test "should set editingContent from the first slide" <|
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
                    ]
                ]
            , describe "given invalid JSON"
                [ describe "when attempting to load from local storage"
                    [ test "should not modify the model" <|
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
            ]
        ]
