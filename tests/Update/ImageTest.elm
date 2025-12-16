module Update.ImageTest exposing (suite)

import Expect
import Test exposing (Test, describe, test)
import Types exposing (Slide, initialModel)
import Update.Image


defaultSlide : Slide
defaultSlide =
    { content = "# Slide", image = Nothing }


slideWithImage : Slide
slideWithImage =
    { content = "# Slide", image = Just "data:image/png;base64,abc123" }


modelWithSlides : List Slide -> Types.Model
modelWithSlides slides =
    let
        presentation =
            { title = "Test"
            , author = "Tester"
            , created = "2025-01-01"
            , slides = slides
            }
    in
    { initialModel
        | presentation = presentation
        , currentSlideIndex = 0
    }


suite : Test
suite =
    describe "Update.Image"
        [ describe "imagePasted"
            [ test "adds image to current slide" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]
                                |> (\m -> { m | currentSlideIndex = 1 })

                        dataUri =
                            "data:image/png;base64,test"

                        ( newModel, _ ) =
                            Update.Image.imagePasted dataUri model

                        currentSlide =
                            List.drop 1 newModel.presentation.slides
                                |> List.head
                    in
                    case currentSlide of
                        Just slide ->
                            Expect.equal (Just dataUri) slide.image

                        Nothing ->
                            Expect.fail "Expected slide to exist"
            , test "does not affect other slides" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide, defaultSlide ]
                                |> (\m -> { m | currentSlideIndex = 1 })

                        ( newModel, _ ) =
                            Update.Image.imagePasted "data:image/png;base64,test" model

                        firstSlide =
                            List.head newModel.presentation.slides
                    in
                    case firstSlide of
                        Just slide ->
                            Expect.equal Nothing slide.image

                        Nothing ->
                            Expect.fail "Expected slide to exist"
            ]
        , describe "imageFileLoaded"
            [ test "sets image on current slide" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide ]

                        dataUri =
                            "data:image/png;base64,loaded"

                        ( newModel, _ ) =
                            Update.Image.imageFileLoaded dataUri model

                        currentSlide =
                            List.head newModel.presentation.slides
                    in
                    case currentSlide of
                        Just slide ->
                            Expect.equal (Just dataUri) slide.image

                        Nothing ->
                            Expect.fail "Expected slide to exist"
            ]
        , describe "removeImage"
            [ test "removes image from current slide" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ slideWithImage ]

                        ( newModel, _ ) =
                            Update.Image.removeImage model

                        currentSlide =
                            List.head newModel.presentation.slides
                    in
                    case currentSlide of
                        Just slide ->
                            Expect.equal Nothing slide.image

                        Nothing ->
                            Expect.fail "Expected slide to exist"
            , test "does not affect slides without images" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide ]

                        ( newModel, _ ) =
                            Update.Image.removeImage model

                        currentSlide =
                            List.head newModel.presentation.slides
                    in
                    case currentSlide of
                        Just slide ->
                            Expect.equal Nothing slide.image

                        Nothing ->
                            Expect.fail "Expected slide to exist"
            ]
        ]
