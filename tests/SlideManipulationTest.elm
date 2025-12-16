module SlideManipulationTest exposing (..)

import Expect
import Test exposing (..)
import Types exposing (Slide, SlideLayout(..))
import SlideManipulation exposing (..)


-- Helper functions

makeSlide : String -> Slide
makeSlide content =
    { content = content
    , layout = JustMarkdown
    , image = Nothing
    }


suite : Test
suite =
    describe "Slide Manipulation Functions"
        [ describe "addSlide"
            [ test "adds a new slide to empty list" <|
                \_ ->
                    let
                        result = addSlide []
                    in
                    Expect.equal (List.length result) 1
            , test "adds a new slide to end of list" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = addSlide slides
                    in
                    Expect.equal (List.length result) 3
            , test "new slide has default content" <|
                \_ ->
                    let
                        result = addSlide []
                    in
                    case List.head result of
                        Just slide ->
                            Expect.equal slide.content "# New Slide"
                        Nothing ->
                            Expect.fail "Expected a slide"
            , test "new slide has JustMarkdown layout" <|
                \_ ->
                    let
                        result = addSlide []
                    in
                    case List.head result of
                        Just slide ->
                            Expect.equal slide.layout JustMarkdown
                        Nothing ->
                            Expect.fail "Expected a slide"
            , test "new slide has no image" <|
                \_ ->
                    let
                        result = addSlide []
                    in
                    case List.head result of
                        Just slide ->
                            Expect.equal slide.image Nothing
                        Nothing ->
                            Expect.fail "Expected a slide"
            ]
        , describe "deleteSlide"
            [ test "cannot delete from single-slide presentation" <|
                \_ ->
                    let
                        slides = [ makeSlide "Only" ]
                        result = deleteSlide 0 slides
                    in
                    Expect.equal result slides
            , test "cannot delete from empty list" <|
                \_ ->
                    let
                        slides = []
                        result = deleteSlide 0 slides
                    in
                    Expect.equal result slides
            , test "deletes first slide" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                        result = deleteSlide 0 slides
                    in
                    Expect.equal result [ makeSlide "Second", makeSlide "Third" ]
            , test "deletes middle slide" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                        result = deleteSlide 1 slides
                    in
                    Expect.equal result [ makeSlide "First", makeSlide "Third" ]
            , test "deletes last slide" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                        result = deleteSlide 2 slides
                    in
                    Expect.equal result [ makeSlide "First", makeSlide "Second" ]
            , test "out of bounds index does not delete" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = deleteSlide 5 slides
                    in
                    Expect.equal result slides
            , test "negative index does not delete" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = deleteSlide -1 slides
                    in
                    Expect.equal result slides
            ]
        , describe "duplicateSlide"
            [ test "duplicates first slide" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = duplicateSlide 0 slides
                    in
                    Expect.equal result [ makeSlide "First", makeSlide "First", makeSlide "Second" ]
            , test "duplicates middle slide" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                        result = duplicateSlide 1 slides
                    in
                    Expect.equal result [ makeSlide "First", makeSlide "Second", makeSlide "Second", makeSlide "Third" ]
            , test "duplicates last slide" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = duplicateSlide 1 slides
                    in
                    Expect.equal result [ makeSlide "First", makeSlide "Second", makeSlide "Second" ]
            , test "out of bounds index returns original list" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = duplicateSlide 5 slides
                    in
                    Expect.equal result slides
            , test "duplicates slide with all properties" <|
                \_ ->
                    let
                        originalSlide = 
                            { content = "Special Content"
                            , layout = MarkdownWithImage
                            , image = Just "data:image/png;base64,test"
                            }
                        slides = [ makeSlide "First", originalSlide, makeSlide "Third" ]
                        result = duplicateSlide 1 slides
                    in
                    case List.drop 2 result |> List.head of
                        Just duplicatedSlide ->
                            Expect.equal duplicatedSlide originalSlide
                        Nothing ->
                            Expect.fail "Expected duplicated slide"
            ]
        , describe "moveSlideUp"
            [ test "cannot move first slide up" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = moveSlideUp 0 slides
                    in
                    Expect.equal result slides
            , test "moves second slide to first position" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = moveSlideUp 1 slides
                    in
                    Expect.equal result [ makeSlide "Second", makeSlide "First" ]
            , test "moves middle slide up one position" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                        result = moveSlideUp 2 slides
                    in
                    Expect.equal result [ makeSlide "First", makeSlide "Third", makeSlide "Second" ]
            , test "out of bounds index returns original list" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = moveSlideUp 5 slides
                    in
                    Expect.equal result slides
            ]
        , describe "moveSlideDown"
            [ test "cannot move last slide down" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = moveSlideDown 1 slides
                    in
                    Expect.equal result slides
            , test "moves first slide to second position" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = moveSlideDown 0 slides
                    in
                    Expect.equal result [ makeSlide "Second", makeSlide "First" ]
            , test "moves middle slide down one position" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                        result = moveSlideDown 0 slides
                    in
                    Expect.equal result [ makeSlide "Second", makeSlide "First", makeSlide "Third" ]
            , test "out of bounds index returns original list" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = moveSlideDown 5 slides
                    in
                    Expect.equal result slides
            ]
        , describe "swapSlides"
            [ test "swaps first and second slides" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                        result = swapSlides 0 1 slides
                    in
                    Expect.equal result [ makeSlide "Second", makeSlide "First", makeSlide "Third" ]
            , test "swaps second and third slides" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                        result = swapSlides 1 2 slides
                    in
                    Expect.equal result [ makeSlide "First", makeSlide "Third", makeSlide "Second" ]
            , test "swaps first and last slides" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second", makeSlide "Third" ]
                        result = swapSlides 0 2 slides
                    in
                    Expect.equal result [ makeSlide "Third", makeSlide "Second", makeSlide "First" ]
            , test "swapping with same index returns original" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = swapSlides 0 0 slides
                    in
                    Expect.equal result slides
            , test "out of bounds first index returns original" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = swapSlides 5 1 slides
                    in
                    Expect.equal result slides
            , test "out of bounds second index returns original" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = swapSlides 0 5 slides
                    in
                    Expect.equal result slides
            , test "negative indices return original" <|
                \_ ->
                    let
                        slides = [ makeSlide "First", makeSlide "Second" ]
                        result = swapSlides -1 1 slides
                    in
                    Expect.equal result slides
            , test "preserves all slide properties" <|
                \_ ->
                    let
                        slide1 = 
                            { content = "Content 1"
                            , layout = JustMarkdown
                            , image = Nothing
                            }
                        slide2 = 
                            { content = "Content 2"
                            , layout = MarkdownWithImage
                            , image = Just "data:image/png;base64,test"
                            }
                        slides = [ slide1, slide2 ]
                        result = swapSlides 0 1 slides
                    in
                    Expect.equal result [ slide2, slide1 ]
            ]
        ]
