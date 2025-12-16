module Update.Storage exposing (localStorageLoaded)

{-| Update handlers for local storage operations.

This module handles loading presentations from local storage.

-}

import Json as AppJson
import Json.Decode as Decode
import Types exposing (Model, Msg)


{-| Load presentation data from local storage JSON string.
-}
localStorageLoaded : String -> Model -> ( Model, Cmd Msg )
localStorageLoaded content model =
    if String.isEmpty content then
        ( model, Cmd.none )

    else
        case Decode.decodeString AppJson.decodePresentation content of
            Ok presentation ->
                let
                    firstSlideContent =
                        List.head presentation.slides
                            |> Maybe.map .content
                            |> Maybe.withDefault ""
                in
                ( { model
                    | presentation = presentation
                    , currentSlideIndex = 0
                    , editingContent = firstSlideContent
                  }
                , Cmd.none
                )

            Err _ ->
                ( model, Cmd.none )
