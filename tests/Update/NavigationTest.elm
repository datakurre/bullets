module Update.NavigationTest exposing (suite)

import Expect
import I18n
import Test exposing (Test, describe, test)
import Types exposing (Model, Slide, initialModel)
import Update.Navigation



-- HELPERS


defaultSlide : Slide
defaultSlide =
    { content = "# Slide", image = Nothing }


modelWithSlides : Int -> Model
modelWithSlides count =
    let
        slides =
            List.repeat count defaultSlide

        presentation =
            { title = "Test"
            , author = "Tester"
            , created = "2025-01-01"
            , slides = slides
            }
    in
    { initialModel | presentation = presentation }



-- TESTS


suite : Test
suite =
    describe "Update.Navigation"
        [ describe "nextSlide"
            [ describe "given a presentation with multiple slides"
                [ describe "when navigating to next slide from the first slide"
                    [ test "should move to the next slide" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides 3
                                        |> (\m -> { m | currentSlideIndex = 0 })

                                ( newModel, _ ) =
                                    Update.Navigation.nextSlide model
                            in
                            Expect.equal 1 newModel.currentSlideIndex
                    , test "should announce the new slide number" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides 3
                                        |> (\m -> { m | currentSlideIndex = 0 })

                                ( newModel, _ ) =
                                    Update.Navigation.nextSlide model

                                t =
                                    I18n.translations model.language
                            in
                            Expect.equal (t.slideAnnouncement 2 3) newModel.announcement
                    ]
                , describe "when at the last slide"
                    [ test "should stay at the last slide" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides 3
                                        |> (\m -> { m | currentSlideIndex = 2 })

                                ( newModel, _ ) =
                                    Update.Navigation.nextSlide model
                            in
                            Expect.equal 2 newModel.currentSlideIndex
                    ]
                ]
            ]
        , describe "prevSlide"
            [ describe "given a presentation with multiple slides"
                [ describe "when navigating to previous slide from the last slide"
                    [ test "should move to the previous slide" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides 3
                                        |> (\m -> { m | currentSlideIndex = 2 })

                                ( newModel, _ ) =
                                    Update.Navigation.prevSlide model
                            in
                            Expect.equal 1 newModel.currentSlideIndex
                    , test "should announce the new slide number" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides 3
                                        |> (\m -> { m | currentSlideIndex = 2 })

                                ( newModel, _ ) =
                                    Update.Navigation.prevSlide model

                                t =
                                    I18n.translations model.language
                            in
                            Expect.equal (t.slideAnnouncement 2 3) newModel.announcement
                    ]
                , describe "when at the first slide"
                    [ test "should stay at the first slide" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides 3
                                        |> (\m -> { m | currentSlideIndex = 0 })

                                ( newModel, _ ) =
                                    Update.Navigation.prevSlide model
                            in
                            Expect.equal 0 newModel.currentSlideIndex
                    ]
                ]
            ]
        , describe "goToSlide"
            [ describe "given a presentation with multiple slides"
                [ describe "when navigating to a specific slide"
                    [ test "should navigate to the specified slide" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides 5
                                        |> (\m -> { m | currentSlideIndex = 0 })

                                ( newModel, _ ) =
                                    Update.Navigation.goToSlide 3 model
                            in
                            Expect.equal 3 newModel.currentSlideIndex
                    , test "should announce the new slide number" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides 5
                                        |> (\m -> { m | currentSlideIndex = 0 })

                                ( newModel, _ ) =
                                    Update.Navigation.goToSlide 3 model

                                t =
                                    I18n.translations model.language
                            in
                            Expect.equal (t.slideAnnouncement 4 5) newModel.announcement
                    ]
                , describe "when navigating to the first slide"
                    [ test "should allow navigation to the first slide" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides 3
                                        |> (\m -> { m | currentSlideIndex = 2 })

                                ( newModel, _ ) =
                                    Update.Navigation.goToSlide 0 model
                            in
                            Expect.equal 0 newModel.currentSlideIndex
                    ]
                ]
            ]
        ]
