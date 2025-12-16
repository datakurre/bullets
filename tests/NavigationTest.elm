module NavigationTest exposing (..)

import Expect
import Navigation exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Navigation Functions"
        [ describe "nextSlide"
            [ test "moves from first to second slide" <|
                \_ ->
                    let
                        result = nextSlide 0 5
                    in
                    Expect.equal result 1
            , test "moves from middle slide to next" <|
                \_ ->
                    let
                        result = nextSlide 2 5
                    in
                    Expect.equal result 3
            , test "stays at last slide when at end" <|
                \_ ->
                    let
                        result = nextSlide 4 5
                    in
                    Expect.equal result 4
            , test "handles single slide presentation" <|
                \_ ->
                    let
                        result = nextSlide 0 1
                    in
                    Expect.equal result 0
            , test "clamps to max index" <|
                \_ ->
                    let
                        result = nextSlide 10 5
                    in
                    Expect.equal result 4
            , test "handles empty presentation" <|
                \_ ->
                    let
                        result = nextSlide 0 0
                    in
                    -- With 0 total slides, max index is -1, so it should clamp to -1
                    Expect.equal result -1
            ]
        , describe "prevSlide"
            [ test "moves from second to first slide" <|
                \_ ->
                    let
                        result = prevSlide 1
                    in
                    Expect.equal result 0
            , test "moves from middle slide to previous" <|
                \_ ->
                    let
                        result = prevSlide 3
                    in
                    Expect.equal result 2
            , test "stays at first slide when at beginning" <|
                \_ ->
                    let
                        result = prevSlide 0
                    in
                    Expect.equal result 0
            , test "moves from last slide" <|
                \_ ->
                    let
                        result = prevSlide 4
                    in
                    Expect.equal result 3
            , test "handles negative index" <|
                \_ ->
                    let
                        result = prevSlide -5
                    in
                    Expect.equal result 0
            ]
        , describe "goToSlide"
            [ test "navigates to first slide" <|
                \_ ->
                    let
                        result = goToSlide 0
                    in
                    Expect.equal result 0
            , test "navigates to middle slide" <|
                \_ ->
                    let
                        result = goToSlide 3
                    in
                    Expect.equal result 3
            , test "navigates to last slide" <|
                \_ ->
                    let
                        result = goToSlide 10
                    in
                    Expect.equal result 10
            , test "allows negative index" <|
                \_ ->
                    let
                        result = goToSlide -1
                    in
                    Expect.equal result -1
            , test "allows out of bounds index" <|
                \_ ->
                    let
                        result = goToSlide 100
                    in
                    Expect.equal result 100
            ]
        , describe "navigation sequences"
            [ test "next then previous returns to same slide" <|
                \_ ->
                    let
                        start = 2
                        afterNext = nextSlide start 5
                        afterPrev = prevSlide afterNext
                    in
                    Expect.equal afterPrev start
            , test "moving through all slides forwards" <|
                \_ ->
                    let
                        totalSlides = 3
                        slide0 = 0
                        slide1 = nextSlide slide0 totalSlides
                        slide2 = nextSlide slide1 totalSlides
                        slide3 = nextSlide slide2 totalSlides
                    in
                    Expect.all
                        [ \_ -> Expect.equal slide0 0
                        , \_ -> Expect.equal slide1 1
                        , \_ -> Expect.equal slide2 2
                        , \_ -> Expect.equal slide3 2  -- Should stay at last
                        ]
                        ()
            , test "moving through all slides backwards" <|
                \_ ->
                    let
                        slide2 = 2
                        slide1 = prevSlide slide2
                        slide0 = prevSlide slide1
                        slideNeg = prevSlide slide0
                    in
                    Expect.all
                        [ \_ -> Expect.equal slide2 2
                        , \_ -> Expect.equal slide1 1
                        , \_ -> Expect.equal slide0 0
                        , \_ -> Expect.equal slideNeg 0  -- Should stay at first
                        ]
                        ()
            , test "going to slide then navigating" <|
                \_ ->
                    let
                        start = goToSlide 5
                        next = nextSlide start 10
                        prev = prevSlide start
                    in
                    Expect.all
                        [ \_ -> Expect.equal start 5
                        , \_ -> Expect.equal next 6
                        , \_ -> Expect.equal prev 4
                        ]
                        ()
            ]
        ]
