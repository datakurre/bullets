module Update.FileIOTest exposing (suite)

import Expect
import Test exposing (Test, describe, test)
import Types exposing (initialModel)
import Update.FileIO


suite : Test
suite =
    describe "Update.FileIO"
        [ describe "exportToPPTX"
            [ test "does not modify model" <|
                \_ ->
                    let
                        model =
                            initialModel

                        ( newModel, _ ) =
                            Update.FileIO.exportToPPTX model
                    in
                    Expect.equal model newModel
            ]
        , describe "importPPTXRequested"
            [ test "does not modify model" <|
                \_ ->
                    let
                        model =
                            initialModel

                        ( newModel, _ ) =
                            Update.FileIO.importPPTXRequested model
                    in
                    Expect.equal model newModel
            ]
        , describe "pptxImported"
            [ test "loads valid presentation JSON" <|
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
            , test "sets currentSlideIndex to 0" <|
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
            , test "sets editingContent from first slide" <|
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
            , test "ignores invalid JSON" <|
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
