module Update.Content exposing (updateContent, updateTitle)

{-| Update handlers for content editing.

This module handles updating slide content and presentation title.

-}

import Json as AppJson
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


{-| Update the content of the current slide.
-}
updateContent : String -> Model -> ( Model, Cmd Msg )
updateContent content model =
    let
        presentation =
            model.presentation

        updatedSlides =
            List.indexedMap
                (\i slide ->
                    if i == model.currentSlideIndex then
                        { slide | content = content }

                    else
                        slide
                )
                presentation.slides

        updatedPresentation =
            { presentation | slides = updatedSlides }
    in
    ( { model
        | editingContent = content
        , presentation = updatedPresentation
      }
    , savePresentation updatedPresentation
    )


{-| Update the presentation title.
-}
updateTitle : String -> Model -> ( Model, Cmd Msg )
updateTitle title model =
    let
        presentation =
            model.presentation

        updatedPresentation =
            { presentation | title = title }
    in
    ( { model
        | presentation = updatedPresentation
      }
    , savePresentation updatedPresentation
    )
