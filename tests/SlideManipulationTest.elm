module SlideManipulationTest exposing (..)

import Expect
import SlideManipulation exposing (..)
import Test exposing (..)
import Types exposing (Slide)



-- Helper functions


makeSlide : String -> Slide
makeSlide content =
    { content = content
    , image = Nothing
    }


suite : Test
suite =
    describe "Slide Manipulation"
        [ describe "addSlide"
            [ describe "given an empty presentation"
                [ test "should add a new slide" <|
                    \_ ->
                        addSlide []
                            |> List.length
                            |> Expect.equal 1
                , test "should create slide with default content" <|
                    \_ ->
                        case addSlide [] |> List.head of
                            Just slide ->
                                Expect.equal slide.content "# New Slide"

                            Nothing ->
                                Expect.fail "Expected a slide"
                , test "should create slide with no image" <|
                    \_ ->
                        case addSlide [] |> List.head of
                            Just slide ->
                                Expect.equal slide.image Nothing

                            Nothing ->
                                Expect.fail "Expected a slide"
                ]
            , describe "given an existing presentation"
                [ test "should add new slide to end of list" <|
                    \_ ->
                        let
                            slides =
                                [ makeSlide "First", makeSlide "Second" ]
                        in
                        addSlide slides
                            |> List.length
                            |> Expect.equal 3
                ]
            ]
        , describe "deleteSlide"
            [ describe "given edge cases"
                [ test "should not delete from single-slide presentation" <|
                    \_ ->
                        let
                            slides =
                                [ makeSlide "Only" ]
                        in
                        deleteSlide 0 slides
                            |> Expect.equal slides
                , test "should not delete from empty list" <|
                    \_ ->
                        deleteSlide 0 []
                            |> Expect.equal []
                ]
            , describe "given a multi-slide presentation"
                [ describe "when deleting at valid positions"
                    [ test "should delete first slide" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            deleteSlide 0 slides
                                |> Expect.equal [ makeSlide "Second", makeSlide "Third" ]
                    , test "should delete middle slide" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            deleteSlide 1 slides
                                |> Expect.equal [ makeSlide "First", makeSlide "Third" ]
                    , test "should delete last slide" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            deleteSlide 2 slides
                                |> Expect.equal [ makeSlide "First", makeSlide "Second" ]
                    ]
                , describe "when index is out of bounds"
                    [ test "should not delete with out of bounds index" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            deleteSlide 5 slides
                                |> Expect.equal slides
                    , test "should not delete with negative index" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            deleteSlide -1 slides
                                |> Expect.equal slides
                    ]
                ]
            ]
        , describe "duplicateSlide"
            [ describe "given a presentation with slides"
                [ describe "when duplicating at valid positions"
                    [ test "should duplicate first slide" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            duplicateSlide 0 slides
                                |> Expect.equal [ makeSlide "First", makeSlide "First", makeSlide "Second" ]
                    , test "should duplicate middle slide" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            duplicateSlide 1 slides
                                |> Expect.equal [ makeSlide "First", makeSlide "Second", makeSlide "Second", makeSlide "Third" ]
                    , test "should duplicate last slide" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            duplicateSlide 1 slides
                                |> Expect.equal [ makeSlide "First", makeSlide "Second", makeSlide "Second" ]
                    ]
                , describe "when duplicating slides with properties"
                    [ test "should preserve all slide properties" <|
                        \_ ->
                            let
                                originalSlide =
                                    { content = "Special Content"
                                    , image = Just "data:image/png;base64,test"
                                    }

                                slides =
                                    [ makeSlide "First", originalSlide, makeSlide "Third" ]
                            in
                            case duplicateSlide 1 slides |> List.drop 2 |> List.head of
                                Just duplicatedSlide ->
                                    Expect.equal duplicatedSlide originalSlide

                                Nothing ->
                                    Expect.fail "Expected duplicated slide"
                    ]
                , describe "when index is out of bounds"
                    [ test "should return original list" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            duplicateSlide 5 slides
                                |> Expect.equal slides
                    ]
                ]
            ]
        , describe "moveSlideUp"
            [ describe "given a presentation with slides"
                [ describe "when moving up from valid positions"
                    [ test "should move second slide to first position" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            moveSlideUp 1 slides
                                |> Expect.equal [ makeSlide "Second", makeSlide "First" ]
                    , test "should move middle slide up one position" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            moveSlideUp 2 slides
                                |> Expect.equal [ makeSlide "First", makeSlide "Third", makeSlide "Second" ]
                    ]
                , describe "when at boundaries"
                    [ test "should not move first slide up" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            moveSlideUp 0 slides
                                |> Expect.equal slides
                    ]
                , describe "when index is out of bounds"
                    [ test "should return original list" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            moveSlideUp 5 slides
                                |> Expect.equal slides
                    ]
                ]
            ]
        , describe "moveSlideDown"
            [ describe "given a presentation with slides"
                [ describe "when moving down from valid positions"
                    [ test "should move first slide to second position" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            moveSlideDown 0 slides
                                |> Expect.equal [ makeSlide "Second", makeSlide "First" ]
                    , test "should move middle slide down one position" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            moveSlideDown 0 slides
                                |> Expect.equal [ makeSlide "Second", makeSlide "First", makeSlide "Third" ]
                    ]
                , describe "when at boundaries"
                    [ test "should not move last slide down" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            moveSlideDown 1 slides
                                |> Expect.equal slides
                    ]
                , describe "when index is out of bounds"
                    [ test "should return original list" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            moveSlideDown 5 slides
                                |> Expect.equal slides
                    ]
                ]
            ]
        , describe "swapSlides"
            [ describe "given a presentation with slides"
                [ describe "when swapping valid positions"
                    [ test "should swap first and second slides" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            swapSlides 0 1 slides
                                |> Expect.equal [ makeSlide "Second", makeSlide "First", makeSlide "Third" ]
                    , test "should swap second and third slides" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            swapSlides 1 2 slides
                                |> Expect.equal [ makeSlide "First", makeSlide "Third", makeSlide "Second" ]
                    , test "should swap first and last slides" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            swapSlides 0 2 slides
                                |> Expect.equal [ makeSlide "Third", makeSlide "Second", makeSlide "First" ]
                    ]
                , describe "when swapping with same index"
                    [ test "should return original list" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            swapSlides 0 0 slides
                                |> Expect.equal slides
                    ]
                , describe "when indices are out of bounds"
                    [ test "should return original with out of bounds first index" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            swapSlides 5 1 slides
                                |> Expect.equal slides
                    , test "should return original with out of bounds second index" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            swapSlides 0 5 slides
                                |> Expect.equal slides
                    , test "should return original with negative indices" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            swapSlides -1 1 slides
                                |> Expect.equal slides
                    ]
                , describe "when preserving properties"
                    [ test "should preserve all slide properties" <|
                        \_ ->
                            let
                                slide1 =
                                    { content = "Content 1"
                                    , image = Nothing
                                    }

                                slide2 =
                                    { content = "Content 2"
                                    , image = Just "data:image/png;base64,test"
                                    }

                                slides =
                                    [ slide1, slide2 ]
                            in
                            swapSlides 0 1 slides
                                |> Expect.equal [ slide2, slide1 ]
                    ]
                ]
            ]
        , describe "moveSlide"
            [ describe "given a presentation with slides"
                [ describe "when moving slides forward"
                    [ test "should move slide from start to end" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            moveSlide 0 2 slides
                                |> Expect.equal [ makeSlide "Second", makeSlide "Third", makeSlide "First" ]
                    , test "should move slide one position forward" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            moveSlide 0 1 slides
                                |> Expect.equal [ makeSlide "Second", makeSlide "First", makeSlide "Third" ]
                    ]
                , describe "when moving slides backward"
                    [ test "should move slide from end to start" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            moveSlide 2 0 slides
                                |> Expect.equal [ makeSlide "Third", makeSlide "First", makeSlide "Second" ]
                    , test "should move slide one position backward" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            moveSlide 1 0 slides
                                |> Expect.equal [ makeSlide "Second", makeSlide "First", makeSlide "Third" ]
                    , test "should move last slide to first position" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            moveSlide 2 0 slides
                                |> Expect.equal [ makeSlide "Third", makeSlide "First", makeSlide "Second" ]
                    ]
                , describe "when moving to same position"
                    [ test "should return original list" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                            in
                            moveSlide 1 1 slides
                                |> Expect.equal slides
                    ]
                , describe "when indices are out of bounds"
                    [ test "should return original with out of bounds source" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            moveSlide 5 0 slides
                                |> Expect.equal slides
                    , test "should return original with out of bounds target" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            moveSlide 0 5 slides
                                |> Expect.equal slides
                    , test "should return original with negative source" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            moveSlide -1 0 slides
                                |> Expect.equal slides
                    , test "should return original with negative target" <|
                        \_ ->
                            let
                                slides =
                                    [ makeSlide "First", makeSlide "Second" ]
                            in
                            moveSlide 0 -1 slides
                                |> Expect.equal slides
                    ]
                , describe "when preserving properties"
                    [ test "should preserve all slide properties" <|
                        \_ ->
                            let
                                slide1 =
                                    makeSlide "Content 1"

                                slide2 =
                                    { content = "Content 2"
                                    , image = Just "data:image/png;base64,test"
                                    }

                                slide3 =
                                    makeSlide "Content 3"

                                slides =
                                    [ slide1, slide2, slide3 ]
                            in
                            moveSlide 1 0 slides
                                |> Expect.equal [ slide2, slide1, slide3 ]
                    ]
                ]
            ]
        ]
