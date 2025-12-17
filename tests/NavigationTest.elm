module NavigationTest exposing (..)

import Expect
import Navigation exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Navigation"
        [ describe "nextSlide"
            [ describe "given a presentation with multiple slides"
                [ describe "when moving forward"
                    [ test "should move from first to second slide" <|
                        \_ ->
                            nextSlide 0 5
                                |> Expect.equal 1
                    , test "should move from middle slide to next" <|
                        \_ ->
                            nextSlide 2 5
                                |> Expect.equal 3
                    ]
                , describe "when at the boundaries"
                    [ test "should stay at last slide when at end" <|
                        \_ ->
                            nextSlide 4 5
                                |> Expect.equal 4
                    , test "should clamp out of bounds index to max" <|
                        \_ ->
                            nextSlide 10 5
                                |> Expect.equal 4
                    ]
                ]
            , describe "given edge case presentations"
                [ test "should handle single slide presentation" <|
                    \_ ->
                        nextSlide 0 1
                            |> Expect.equal 0
                , test "should handle empty presentation" <|
                    \_ ->
                        -- With 0 total slides, max index is -1
                        nextSlide 0 0
                            |> Expect.equal -1
                ]
            ]
        , describe "prevSlide"
            [ describe "given any presentation"
                [ describe "when moving backward"
                    [ test "should move from second to first slide" <|
                        \_ ->
                            prevSlide 1
                                |> Expect.equal 0
                    , test "should move from middle slide to previous" <|
                        \_ ->
                            prevSlide 3
                                |> Expect.equal 2
                    , test "should move from last slide" <|
                        \_ ->
                            prevSlide 4
                                |> Expect.equal 3
                    ]
                , describe "when at the boundaries"
                    [ test "should stay at first slide when at beginning" <|
                        \_ ->
                            prevSlide 0
                                |> Expect.equal 0
                    , test "should clamp negative index to zero" <|
                        \_ ->
                            prevSlide -5
                                |> Expect.equal 0
                    ]
                ]
            ]
        , describe "goToSlide"
            [ describe "given any target index"
                [ test "should navigate to first slide" <|
                    \_ ->
                        goToSlide 0
                            |> Expect.equal 0
                , test "should navigate to middle slide" <|
                    \_ ->
                        goToSlide 3
                            |> Expect.equal 3
                , test "should navigate to last slide" <|
                    \_ ->
                        goToSlide 10
                            |> Expect.equal 10
                , test "should allow negative index" <|
                    \_ ->
                        goToSlide -1
                            |> Expect.equal -1
                , test "should allow out of bounds index" <|
                    \_ ->
                        goToSlide 100
                            |> Expect.equal 100
                ]
            ]
        , describe "navigation sequences"
            [ describe "given a multi-slide presentation"
                [ test "should return to same slide after next then previous" <|
                    \_ ->
                        let
                            start =
                                2

                            afterNext =
                                nextSlide start 5

                            afterPrev =
                                prevSlide afterNext
                        in
                        Expect.equal start afterPrev
                , test "should navigate through all slides forwards correctly" <|
                    \_ ->
                        let
                            totalSlides =
                                3

                            positions =
                                [ 0
                                , nextSlide 0 totalSlides
                                , nextSlide 0 totalSlides |> (\i -> nextSlide i totalSlides)
                                , nextSlide 0 totalSlides |> (\i -> nextSlide i totalSlides) |> (\i -> nextSlide i totalSlides)
                                ]
                        in
                        Expect.equal positions [ 0, 1, 2, 2 ]
                , test "should navigate through all slides backwards correctly" <|
                    \_ ->
                        let
                            positions =
                                [ 2
                                , prevSlide 2
                                , prevSlide 2 |> prevSlide
                                , prevSlide 2 |> prevSlide |> prevSlide
                                ]
                        in
                        Expect.equal positions [ 2, 1, 0, 0 ]
                , test "should navigate correctly after going to specific slide" <|
                    \_ ->
                        let
                            start =
                                goToSlide 5

                            next =
                                nextSlide start 10

                            prev =
                                prevSlide start
                        in
                        Expect.all
                            [ \_ -> Expect.equal start 5
                            , \_ -> Expect.equal next 6
                            , \_ -> Expect.equal prev 4
                            ]
                            ()
                ]
            ]
        ]
