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
            [ test "switches mode to Present" <|
                \_ ->
                    let
                        model =
                            { initialModel | mode = Edit }

                        ( newModel, _ ) =
                            Update.Mode.enterPresentMode model
                    in
                    Expect.equal Present newModel.mode
            , test "sets announcement for entering presentation mode" <|
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
        , describe "exitPresentMode"
            [ test "switches mode to Edit" <|
                \_ ->
                    let
                        model =
                            { initialModel | mode = Present }

                        ( newModel, _ ) =
                            Update.Mode.exitPresentMode model
                    in
                    Expect.equal Edit newModel.mode
            , test "sets announcement for exiting presentation mode" <|
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
