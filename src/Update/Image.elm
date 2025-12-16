module Update.Image exposing (imageFileLoaded, imageFileSelected, imagePasted, imageUploadRequested, removeImage)

{-| Update handlers for image operations.

This module handles pasting, uploading, loading, and removing images from slides.

-}

import File
import File.Select as Select
import Json as AppJson
import Json.Encode as Encode
import Ports
import Task
import Types exposing (Model, Msg(..), Presentation)


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


{-| Handle image pasted from clipboard.
-}
imagePasted : String -> Model -> ( Model, Cmd Msg )
imagePasted dataUri model =
    let
        presentation =
            model.presentation

        updatedSlides =
            List.indexedMap
                (\i slide ->
                    if i == model.currentSlideIndex then
                        { slide | image = Just dataUri }

                    else
                        slide
                )
                presentation.slides

        updatedPresentation =
            { presentation | slides = updatedSlides }
    in
    ( { model | presentation = updatedPresentation }, savePresentation updatedPresentation )


{-| Remove image from current slide.
-}
removeImage : Model -> ( Model, Cmd Msg )
removeImage model =
    let
        presentation =
            model.presentation

        updatedSlides =
            List.indexedMap
                (\i slide ->
                    if i == model.currentSlideIndex then
                        { slide | image = Nothing }

                    else
                        slide
                )
                presentation.slides

        updatedPresentation =
            { presentation | slides = updatedSlides }
    in
    ( { model | presentation = updatedPresentation }, savePresentation updatedPresentation )


{-| Request image file upload from user.
-}
imageUploadRequested : Model -> ( Model, Cmd Msg )
imageUploadRequested model =
    ( model, Select.file [ "image/png", "image/jpeg", "image/gif", "image/webp" ] ImageFileSelected )


{-| Handle image file selection - convert to data URL.
-}
imageFileSelected : File.File -> Model -> ( Model, Cmd Msg )
imageFileSelected file model =
    ( model, Task.perform ImageFileLoaded (File.toUrl file) )


{-| Handle loaded image data URL.
-}
imageFileLoaded : String -> Model -> ( Model, Cmd Msg )
imageFileLoaded dataUri model =
    let
        presentation =
            model.presentation

        updatedSlides =
            List.indexedMap
                (\i slide ->
                    if i == model.currentSlideIndex then
                        { slide | image = Just dataUri }

                    else
                        slide
                )
                presentation.slides

        updatedPresentation =
            { presentation | slides = updatedSlides }
    in
    ( { model | presentation = updatedPresentation }, savePresentation updatedPresentation )
