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
            [ describe "given a presentation with multiple slides"
                [ describe "when adding a new slide"
                    [ test "should add the slide at the end" <|
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
                    , test "should navigate to the new slide" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide, defaultSlide ]

                                ( newModel, _ ) =
                                    Update.Slide.addSlide model
                            in
                            Expect.equal 2 newModel.currentSlideIndex
                    , test "should set editingContent to new slide content" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide ]

                                ( newModel, _ ) =
                                    Update.Slide.addSlide model
                            in
                            Expect.equal "# New Slide" newModel.editingContent
                    , test "should announce slide addition" <|
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
                ]
            ]
        , describe "addSlideAfter"
            [ describe "given a presentation with multiple slides"
                [ describe "when adding a slide after a specific index"
                    [ test "should insert the slide after the specified position" <|
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
                    , test "should navigate to the new slide" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide, defaultSlide ]

                                ( newModel, _ ) =
                                    Update.Slide.addSlideAfter 0 model
                            in
                            Expect.equal 1 newModel.currentSlideIndex
                    ]
                ]
            ]
        , describe "deleteSlide"
            [ describe "given a presentation with multiple slides"
                [ describe "when deleting a slide"
                    [ test "should remove the slide at the specified index" <|
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
                    , test "should adjust currentSlideIndex when deleting current slide" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide, defaultSlide, defaultSlide ]
                                        |> (\m -> { m | currentSlideIndex = 2 })

                                ( newModel, _ ) =
                                    Update.Slide.deleteSlide 2 model
                            in
                            Expect.equal 1 newModel.currentSlideIndex
                    , test "should announce slide deletion" <|
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
                ]
            , describe "given a presentation with only one slide"
                [ describe "when attempting to delete the last slide"
                    [ test "should prevent deletion of the last slide" <|
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
                    ]
                ]
            ]
        , describe "duplicateSlide"
            [ describe "given a presentation with slides"
                [ describe "when duplicating a slide"
                    [ test "should create a copy after the original slide" <|
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
                    , test "should announce slide duplication" <|
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
                ]
            ]
        , describe "moveSlideUp"
            [ describe "given a presentation with multiple slides"
                [ describe "when moving the first slide up"
                    [ test "should not change the presentation" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide, defaultSlide ]

                                ( newModel, _ ) =
                                    Update.Slide.moveSlideUp 0 model
                            in
                            Expect.equal model.presentation newModel.presentation
                    ]
                , describe "when moving a non-first slide up"
                    [ test "should swap the slide with the one above it" <|
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
                    , test "should adjust currentSlideIndex when moving the current slide" <|
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
                ]
            ]
        , describe "moveSlideDown"
            [ describe "given a presentation with multiple slides"
                [ describe "when moving the last slide down"
                    [ test "should not change the presentation" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide, defaultSlide ]

                                ( newModel, _ ) =
                                    Update.Slide.moveSlideDown 1 model
                            in
                            Expect.equal model.presentation newModel.presentation
                    ]
                , describe "when moving a non-last slide down"
                    [ test "should swap the slide with the one below it" <|
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
                ]
            ]
        , describe "drag and drop"
            [ describe "given a presentation with slides"
                [ describe "when starting a drag operation"
                    [ test "should set the draggedSlideIndex" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide, defaultSlide ]

                                ( newModel, _ ) =
                                    Update.Slide.dragStart 1 model
                            in
                            Expect.equal (Just 1) newModel.draggedSlideIndex
                    ]
                , describe "when dragging over a target"
                    [ test "should set the dropTargetIndex" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide, defaultSlide ]

                                ( newModel, _ ) =
                                    Update.Slide.dragOver 0 model
                            in
                            Expect.equal (Just 0) newModel.dropTargetIndex
                    ]
                , describe "when ending a drag without dropping"
                    [ test "should clear the drag state" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide, defaultSlide ]
                                        |> (\m -> { m | draggedSlideIndex = Just 1, dropTargetIndex = Just 0 })

                                ( newModel, _ ) =
                                    Update.Slide.dragEnd model
                            in
                            Expect.equal Nothing newModel.draggedSlideIndex
                    ]
                , describe "when dropping a slide at a different position"
                    [ test "should move the slide to the target position" <|
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
                    , test "should clear the drag state" <|
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
                , describe "when dropping a slide at the same position"
                    [ test "should not change the presentation" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides [ defaultSlide, defaultSlide ]
                                        |> (\m -> { m | draggedSlideIndex = Just 1 })

                                ( newModel, _ ) =
                                    Update.Slide.drop 1 model
                            in
                            Expect.equal model.presentation newModel.presentation
                    ]
                ]
            ]
        ]
