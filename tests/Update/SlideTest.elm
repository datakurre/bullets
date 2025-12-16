module Update.SlideTest exposing (suite)

import Expect
import I18n
import Test exposing (Test, describe, test)
import Types exposing (Slide, initialModel)
import Update.Slide


defaultSlide : Slide
defaultSlide =
    { content = "# Slide", image = Nothing }


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
        , editingContent = "# Slide"
    }


suite : Test
suite =
    describe "Update.Slide"
        [ describe "addSlide"
            [ test "adds new slide at end" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.addSlide model

                        slideCount =
                            List.length newModel.presentation.slides
                    in
                    Expect.equal 3 slideCount
            , test "sets currentSlideIndex to new slide" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.addSlide model
                    in
                    Expect.equal 2 newModel.currentSlideIndex
            , test "sets editingContent to new slide content" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.addSlide model
                    in
                    Expect.equal "# New Slide" newModel.editingContent
            , test "sets announcement" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.addSlide model

                        t =
                            I18n.translations model.language
                    in
                    Expect.equal t.slideAdded newModel.announcement
            ]
        , describe "addSlideAfter"
            [ test "adds slide after specified index" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide, defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.addSlideAfter 1 model

                        slideCount =
                            List.length newModel.presentation.slides
                    in
                    Expect.equal 4 slideCount
            , test "sets currentSlideIndex to new slide" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.addSlideAfter 0 model
                    in
                    Expect.equal 1 newModel.currentSlideIndex
            ]
        , describe "deleteSlide"
            [ test "removes slide at index" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide, defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.deleteSlide 1 model

                        slideCount =
                            List.length newModel.presentation.slides
                    in
                    Expect.equal 2 slideCount
            , test "prevents deleting last slide" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.deleteSlide 0 model

                        slideCount =
                            List.length newModel.presentation.slides
                    in
                    Expect.equal 1 slideCount
            , test "adjusts currentSlideIndex when needed" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide, defaultSlide ]
                                |> (\m -> { m | currentSlideIndex = 2 })

                        ( newModel, _ ) =
                            Update.Slide.deleteSlide 2 model
                    in
                    Expect.equal 1 newModel.currentSlideIndex
            , test "sets announcement" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.deleteSlide 1 model

                        t =
                            I18n.translations model.language
                    in
                    Expect.equal t.slideDeleted newModel.announcement
            ]
        , describe "duplicateSlide"
            [ test "duplicates slide at index" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.duplicateSlide 0 model

                        slideCount =
                            List.length newModel.presentation.slides
                    in
                    Expect.equal 3 slideCount
            , test "sets announcement" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.duplicateSlide 0 model

                        t =
                            I18n.translations model.language
                    in
                    Expect.equal t.slideDuplicated newModel.announcement
            ]
        , describe "moveSlideUp"
            [ test "does nothing when index is 0" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.moveSlideUp 0 model
                    in
                    Expect.equal model.presentation newModel.presentation
            , test "moves slide up when index > 0" <|
                \_ ->
                    let
                        slide1 =
                            { content = "# First", image = Nothing }

                        slide2 =
                            { content = "# Second", image = Nothing }

                        model =
                            modelWithSlides [ slide1, slide2 ]

                        ( newModel, _ ) =
                            Update.Slide.moveSlideUp 1 model

                        firstSlide =
                            List.head newModel.presentation.slides
                                |> Maybe.map .content
                    in
                    Expect.equal (Just "# Second") firstSlide
            , test "adjusts currentSlideIndex when moving current slide" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide, defaultSlide ]
                                |> (\m -> { m | currentSlideIndex = 2 })

                        ( newModel, _ ) =
                            Update.Slide.moveSlideUp 2 model
                    in
                    Expect.equal 1 newModel.currentSlideIndex
            ]
        , describe "moveSlideDown"
            [ test "does nothing when at last index" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.moveSlideDown 1 model
                    in
                    Expect.equal model.presentation newModel.presentation
            , test "moves slide down when index < max" <|
                \_ ->
                    let
                        slide1 =
                            { content = "# First", image = Nothing }

                        slide2 =
                            { content = "# Second", image = Nothing }

                        model =
                            modelWithSlides [ slide1, slide2 ]

                        ( newModel, _ ) =
                            Update.Slide.moveSlideDown 0 model

                        firstSlide =
                            List.head newModel.presentation.slides
                                |> Maybe.map .content
                    in
                    Expect.equal (Just "# Second") firstSlide
            ]
        , describe "drag and drop"
            [ test "dragStart sets draggedSlideIndex" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.dragStart 1 model
                    in
                    Expect.equal (Just 1) newModel.draggedSlideIndex
            , test "dragOver sets dropTargetIndex" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]

                        ( newModel, _ ) =
                            Update.Slide.dragOver 0 model
                    in
                    Expect.equal (Just 0) newModel.dropTargetIndex
            , test "dragEnd clears drag state" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]
                                |> (\m -> { m | draggedSlideIndex = Just 1, dropTargetIndex = Just 0 })

                        ( newModel, _ ) =
                            Update.Slide.dragEnd model
                    in
                    Expect.equal Nothing newModel.draggedSlideIndex
            , test "drop moves slide to target" <|
                \_ ->
                    let
                        slide1 =
                            { content = "# First", image = Nothing }

                        slide2 =
                            { content = "# Second", image = Nothing }

                        model =
                            modelWithSlides [ slide1, slide2 ]
                                |> (\m -> { m | draggedSlideIndex = Just 1 })

                        ( newModel, _ ) =
                            Update.Slide.drop 0 model

                        firstSlide =
                            List.head newModel.presentation.slides
                                |> Maybe.map .content
                    in
                    Expect.equal (Just "# Second") firstSlide
            , test "drop does nothing when source equals target" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]
                                |> (\m -> { m | draggedSlideIndex = Just 1 })

                        ( newModel, _ ) =
                            Update.Slide.drop 1 model
                    in
                    Expect.equal model.presentation newModel.presentation
            , test "drop clears drag state" <|
                \_ ->
                    let
                        model =
                            modelWithSlides [ defaultSlide, defaultSlide ]
                                |> (\m -> { m | draggedSlideIndex = Just 1, dropTargetIndex = Just 0 })

                        ( newModel, _ ) =
                            Update.Slide.drop 0 model
                    in
                    Expect.equal Nothing newModel.draggedSlideIndex
            ]
        ]
