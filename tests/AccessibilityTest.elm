module AccessibilityTest exposing (..)

import Expect
import Test exposing (Test, describe, test)
import Types exposing (Model, Msg(..), initialModel)


suite : Test
suite =
    describe "Accessibility Announcements"
        [ describe "Live Region Announcements"
            [ test "Initial announcement should be empty" <|
                \_ ->
                    initialModel.announcement
                        |> Expect.equal ""
            , test "Adding a slide should set announcement" <|
                \_ ->
                    let
                        model =
                            { initialModel | announcement = "" }

                        updatedModel =
                            updateWithAnnouncement AddSlide model
                    in
                    updatedModel.announcement
                        |> Expect.notEqual ""
            , test "Deleting a slide should set announcement" <|
                \_ ->
                    let
                        model =
                            { initialModel | announcement = "" }

                        updatedModel =
                            updateWithAnnouncement (DeleteSlide 0) model
                    in
                    updatedModel.announcement
                        |> Expect.notEqual ""
            , test "Navigating to next slide should announce slide number" <|
                \_ ->
                    let
                        model =
                            { initialModel | announcement = "", currentSlideIndex = 0 }

                        updatedModel =
                            updateWithAnnouncement NextSlide model
                    in
                    updatedModel.announcement
                        |> Expect.notEqual ""
            , test "Entering presentation mode should set announcement" <|
                \_ ->
                    let
                        model =
                            { initialModel | announcement = "" }

                        updatedModel =
                            updateWithAnnouncement EnterPresentMode model
                    in
                    updatedModel.announcement
                        |> Expect.equal "Entering presentation mode"
            , test "Exiting presentation mode should set announcement" <|
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

        _ ->
            model
