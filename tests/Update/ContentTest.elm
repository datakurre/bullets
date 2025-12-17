module Update.ContentTest exposing (suite)

import Expect
import Test exposing (Test, describe, test)
import Types exposing (Slide, initialModel)
import Update.Content


defaultSlide : Slide
defaultSlide =
    { content = "# Original", image = Nothing }


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
        , editingContent = "# Original"
    }


suite : Test
suite =
    describe "Update.Content"
        [ describe "updateContent"
            [ describe "given a presentation with one slide"
                [ describe "when updating content"
                    [ test "should update the editingContent buffer" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide ]

                                ( newModel, _ ) =
                                    Update.Content.updateContent "# Updated" model
                            in
                            Expect.equal "# Updated" newModel.editingContent
                    ]
                ]
            , describe "given a presentation with multiple slides"
                [ describe "when updating content of the second slide"
                    [ test "should update the current slide content" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide, defaultSlide, defaultSlide ]
                                        |> (\m -> { m | currentSlideIndex = 1 })

                                ( newModel, _ ) =
                                    Update.Content.updateContent "# New Content" model

                                currentSlide =
                                    List.drop 1 newModel.presentation.slides
                                        |> List.head
                                        |> Maybe.map .content
                            in
                            Expect.equal (Just "# New Content") currentSlide
                    , test "should not update other slides" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide, defaultSlide, defaultSlide ]
                                        |> (\m -> { m | currentSlideIndex = 1 })

                                ( newModel, _ ) =
                                    Update.Content.updateContent "# New Content" model

                                firstSlide =
                                    List.head newModel.presentation.slides
                                        |> Maybe.map .content
                            in
                            Expect.equal (Just "# Original") firstSlide
                    ]
                ]
            ]
        , describe "updateTitle"
            [ describe "given a presentation"
                [ describe "when updating the title"
                    [ test "should update the presentation title" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide ]

                                ( newModel, _ ) =
                                    Update.Content.updateTitle "New Title" model
                            in
                            Expect.equal "New Title" newModel.presentation.title
                    , test "should not affect slides" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide ]

                                ( newModel, _ ) =
                                    Update.Content.updateTitle "New Title" model

                                slideCount =
                                    List.length newModel.presentation.slides
                            in
                            Expect.equal 1 slideCount
                    ]
                ]
            ]
        ]
