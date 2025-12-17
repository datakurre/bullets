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
            [ test "moves to next slide when not at end" <|
                \_ ->
                    let
                        model =
                            modelWithSlides 3
                                |> (\m -> { m | currentSlideIndex = 0 })

                        ( newModel, _ ) =
                            Update.Navigation.nextSlide model
                    in
                    Expect.equal 1 newModel.currentSlideIndex
            , test "stays at last slide when at end" <|
                \_ ->
                    let
                        model =
                            modelWithSlides 3
                                |> (\m -> { m | currentSlideIndex = 2 })

                        ( newModel, _ ) =
                            Update.Navigation.nextSlide model
                    in
                    Expect.equal 2 newModel.currentSlideIndex
            , test "updates announcement with slide number" <|
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
        , describe "prevSlide"
            [ test "moves to previous slide when not at start" <|
                \_ ->
                    let
                        model =
                            modelWithSlides 3
                                |> (\m -> { m | currentSlideIndex = 2 })

                        ( newModel, _ ) =
                            Update.Navigation.prevSlide model
                    in
                    Expect.equal 1 newModel.currentSlideIndex
            , test "stays at first slide when at start" <|
                \_ ->
                    let
                        model =
                            modelWithSlides 3
                                |> (\m -> { m | currentSlideIndex = 0 })

                        ( newModel, _ ) =
                            Update.Navigation.prevSlide model
                    in
                    Expect.equal 0 newModel.currentSlideIndex
            , test "updates announcement with slide number" <|
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
        , describe "goToSlide"
            [ test "navigates to specified slide" <|
                \_ ->
                    let
                        model =
                            modelWithSlides 5
                                |> (\m -> { m | currentSlideIndex = 0 })

                        ( newModel, _ ) =
                            Update.Navigation.goToSlide 3 model
                    in
                    Expect.equal 3 newModel.currentSlideIndex
            , test "allows navigation to first slide" <|
                \_ ->
                    let
                        model =
                            modelWithSlides 3
                                |> (\m -> { m | currentSlideIndex = 2 })

                        ( newModel, _ ) =
                            Update.Navigation.goToSlide 0 model
                    in
                    Expect.equal 0 newModel.currentSlideIndex
            , test "updates announcement with slide number" <|
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
        ]
