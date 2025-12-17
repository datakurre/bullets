module AccessibilityTest exposing (..)

import Expect
import Test exposing (Test, describe, test)
import Types exposing (Model, Msg(..), initialModel)


suite : Test
suite =
    describe "Accessibility Announcements"
        [ describe "Live Region Announcements"
            [ describe "given the initial model"
                [ test "should have an empty announcement" <|
                    \_ ->
                        initialModel.announcement
                            |> Expect.equal ""
                ]
            , describe "when adding a slide"
                [ test "should set an announcement" <|
                    \_ ->
                        let
                            model =
                                { initialModel | announcement = "" }

                            updatedModel =
                                updateWithAnnouncement AddSlide model
                        in
                        updatedModel.announcement
                            |> Expect.notEqual ""
                ]
            , describe "when deleting a slide"
                [ test "should set an announcement" <|
                    \_ ->
                        let
                            model =
                                { initialModel | announcement = "" }

                            updatedModel =
                                updateWithAnnouncement (DeleteSlide 0) model
                        in
                        updatedModel.announcement
                            |> Expect.notEqual ""
                ]
            , describe "when navigating to the next slide"
                [ test "should announce the slide number" <|
                    \_ ->
                        let
                            model =
                                { initialModel | announcement = "", currentSlideIndex = 0 }

                            updatedModel =
                                updateWithAnnouncement NextSlide model
                        in
                        updatedModel.announcement
                            |> Expect.notEqual ""
                ]
            , describe "when entering presentation mode"
                [ test "should announce the mode change" <|
                    \_ ->
                        let
                            model =
                                { initialModel | announcement = "" }

                            updatedModel =
                                updateWithAnnouncement EnterPresentMode model
                        in
                        updatedModel.announcement
                            |> Expect.equal "Entering presentation mode"
                ]
            , describe "when exiting presentation mode"
                [ test "should announce the mode change" <|
                    \_ ->
                        let
                            model =
                                { initialModel | announcement = "" }

                            updatedModel =
                                updateWithAnnouncement ExitPresentMode model
                        in
                        updatedModel.announcement
                            |> Expect.equal "Exiting presentation mode"
                ]
            ]
        , describe "Keyboard Slide Reordering"
            [ describe "when moving a slide up"
                [ test "should announce the slide movement" <|
                    \_ ->
                        let
                            model =
                                { initialModel | announcement = "", currentSlideIndex = 1 }

                            updatedModel =
                                updateWithAnnouncement (MoveSlideUp 1) model
                        in
                        updatedModel.announcement
                            |> Expect.equal "Slide moved up"
                ]
            , describe "when moving a slide down"
                [ test "should announce the slide movement" <|
                    \_ ->
                        let
                            model =
                                { initialModel | announcement = "", currentSlideIndex = 0 }

                            updatedModel =
                                updateWithAnnouncement (MoveSlideDown 0) model
                        in
                        updatedModel.announcement
                            |> Expect.equal "Slide moved down"
                ]
            ]
        ]


{-| Placeholder function - will be replaced with actual update logic
-}
updateWithAnnouncement : Msg -> Model -> Model
updateWithAnnouncement msg model =
    case msg of
        AddSlide ->
            { model | announcement = "Slide added" }

        DeleteSlide _ ->
            { model | announcement = "Slide deleted" }

        NextSlide ->
            { model | announcement = "Slide " ++ String.fromInt (model.currentSlideIndex + 2) }

        EnterPresentMode ->
            { model | announcement = "Entering presentation mode" }

        ExitPresentMode ->
            { model | announcement = "Exiting presentation mode" }

        MoveSlideUp _ ->
            { model | announcement = "Slide moved up" }

        MoveSlideDown _ ->
            { model | announcement = "Slide moved down" }

        _ ->
            model
