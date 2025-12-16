module Update.FileIO exposing (exportToPPTX, importPPTXRequested, pptxImported)

{-| Update handlers for file I/O operations.

This module handles PowerPoint PPTX import and export.

-}

import Json as AppJson
import Json.Decode as Decode
import Json.Encode as Encode
import Ports
import Types exposing (Model, Msg, Presentation)


{-| Save presentation to local storage.
-}
savePresentation : Presentation -> Cmd Msg
savePresentation presentation =
    let
        json =
            AppJson.encodePresentation presentation

        jsonString =
            Encode.encode 0 json
    in
    Ports.saveToLocalStorage jsonString


{-| Export presentation to PowerPoint PPTX format.
-}
exportToPPTX : Model -> ( Model, Cmd Msg )
exportToPPTX model =
    let
        json =
            AppJson.encodePresentation model.presentation
    in
    ( model, Ports.exportToPPTX json )


{-| Request PowerPoint PPTX file from user.
-}
importPPTXRequested : Model -> ( Model, Cmd Msg )
importPPTXRequested model =
    ( model, Ports.importPPTXRequested () )


{-| Handle imported PowerPoint PPTX data.
-}
pptxImported : String -> Model -> ( Model, Cmd Msg )
pptxImported jsonString model =
    case Decode.decodeString AppJson.decodePresentation jsonString of
        Ok presentation ->
            let
                newModel =
                    { model
                        | presentation = presentation
                        , currentSlideIndex = 0
                        , editingContent =
                            List.head presentation.slides
                                |> Maybe.map .content
                                |> Maybe.withDefault ""
                    }
            in
            ( newModel, savePresentation presentation )

        Err _ ->
            ( model, Cmd.none )
