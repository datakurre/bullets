module Update.ModeTest exposing (suite)

import Expect
import I18n
import Test exposing (Test, describe, test)
import Types exposing (Mode(..), initialModel)
import Update.Mode


suite : Test
suite =
    describe "Update.Mode"
        [ describe "enterPresentMode"
            [ describe "given the application is in edit mode"
                [ describe "when entering presentation mode"
                    [ test "should switch to presentation mode" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | mode = Edit }

                                ( newModel, _ ) =
                                    Update.Mode.enterPresentMode model
                            in
                            Expect.equal Present newModel.mode
                    , test "should announce the mode change" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | mode = Edit }

                                ( newModel, _ ) =
                                    Update.Mode.enterPresentMode model

                                t =
                                    I18n.translations model.language
                            in
                            Expect.equal t.enteringPresentMode newModel.announcement
                    ]
                ]
            ]
        , describe "exitPresentMode"
            [ describe "given the application is in presentation mode"
                [ describe "when exiting presentation mode"
                    [ test "should switch to edit mode" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | mode = Present }

                                ( newModel, _ ) =
                                    Update.Mode.exitPresentMode model
                            in
                            Expect.equal Edit newModel.mode
                    , test "should announce the mode change" <|
                        \_ ->
                            let
                                model =
                                    { initialModel | mode = Present }

                                ( newModel, _ ) =
                                    Update.Mode.exitPresentMode model

                                t =
                                    I18n.translations model.language
                            in
                            Expect.equal t.exitingPresentMode newModel.announcement
                    ]
                ]
            ]
        ]
