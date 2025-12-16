module Update.Mode exposing (enterPresentMode, exitPresentMode)

{-| Update handlers for mode switching.

This module handles transitions between edit and presentation modes.

-}

import I18n
import Types exposing (Mode(..), Model, Msg)


{-| Enter presentation mode (switch from Edit to Present).
-}
enterPresentMode : Model -> ( Model, Cmd Msg )
enterPresentMode model =
    let
        t =
            I18n.translations model.language
    in
    ( { model
        | mode = Present
        , announcement = t.enteringPresentMode
      }
    , Cmd.none
    )


{-| Exit presentation mode (switch from Present to Edit).
-}
exitPresentMode : Model -> ( Model, Cmd Msg )
exitPresentMode model =
    let
        t =
            I18n.translations model.language
    in
    ( { model
        | mode = Edit
        , announcement = t.exitingPresentMode
      }
    , Cmd.none
    )
