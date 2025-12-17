module Update.FileIOTest exposing (suite)

import Expect
import Test exposing (Test, describe, test)
import Types exposing (initialModel)
import Update.FileIO


suite : Test
suite =
    describe "Update.FileIO"
        [ describe "exportToPPTX"
            [ describe "when exporting a presentation"
                [ test "should not modify the model" <|
                    \_ ->
                        let
                            model =
                                initialModel

                            ( newModel, _ ) =
                                Update.FileIO.exportToPPTX model
                        in
                        Expect.equal model newModel
                ]
            ]
        , describe "importPPTXRequested"
            [ describe "when requesting to import a PPTX file"
                [ test "should not modify the model" <|
                    \_ ->
                        let
                            model =
                                initialModel

                            ( newModel, _ ) =
                                Update.FileIO.importPPTXRequested model
                        in
                        Expect.equal model newModel
                ]
            ]
        , describe "pptxImported"
            [ describe "given valid presentation JSON"
                [ describe "when importing a PPTX file"
                    [ test "should load the presentation data" <|
                        \_ ->
                            let
                                model =
                                    initialModel

                                json =
                                    """{"title":"Imported","author":"Importer","created":"2025-01-01","slides":[{"content":"# Imported Slide","image":null}]}"""

                                ( newModel, _ ) =
                                    Update.FileIO.pptxImported json model
                            in
                            Expect.equal "Imported" newModel.presentation.title
                    , test "should reset currentSlideIndex to the first slide" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | currentSlideIndex = 5 }

                                json =
                                    """{"title":"Test","author":"Test","created":"2025-01-01","slides":[{"content":"# Test","image":null}]}"""

                                ( newModel, _ ) =
                                    Update.FileIO.pptxImported json model
                            in
                            Expect.equal 0 newModel.currentSlideIndex
                    , test "should set editingContent from the first slide" <|
                        \_ ->
                            let
                                model =
                                    initialModel

                                json =
                                    """{"title":"Test","author":"Test","created":"2025-01-01","slides":[{"content":"# First","image":null}]}"""

                                ( newModel, _ ) =
                                    Update.FileIO.pptxImported json model
                            in
                            Expect.equal "# First" newModel.editingContent
                    ]
                ]
            , describe "given invalid JSON"
                [ describe "when attempting to import"
                    [ test "should not modify the model" <|
                        \_ ->
                            let
                                model =
                                    initialModel

                                invalidJson =
                                    "not valid json"

                                ( newModel, _ ) =
                                    Update.FileIO.pptxImported invalidJson model
                            in
                            Expect.equal model newModel
                    ]
                ]
            ]
        ]
