module Json exposing (decodePresentation, encodePresentation)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Types exposing (Presentation, Slide)



-- ENCODERS


encodePresentation : Presentation -> Encode.Value
encodePresentation presentation =
    Encode.object
        [ ( "slides", Encode.list encodeSlide presentation.slides )
        , ( "title", Encode.string presentation.title )
        , ( "author", Encode.string presentation.author )
        , ( "created", Encode.string presentation.created )
        ]


encodeSlide : Slide -> Encode.Value
encodeSlide slide =
    let
        layout =
            case slide.image of
                Just _ ->
                    "markdown-with-image"

                Nothing ->
                    "just-markdown"
    in
    Encode.object
        [ ( "content", Encode.string slide.content )
        , ( "image"
          , case slide.image of
                Just img ->
                    Encode.string img

                Nothing ->
                    Encode.null
          )
        , ( "layout", Encode.string layout )
        ]



-- DECODERS


decodePresentation : Decoder Presentation
decodePresentation =
    Decode.map4 Presentation
        (Decode.field "slides" (Decode.list decodeSlide))
        (Decode.field "title" Decode.string)
        (Decode.field "author" Decode.string)
        (Decode.field "created" Decode.string)


decodeSlide : Decoder Slide
decodeSlide =
    Decode.map2 Slide
        (Decode.field "content" Decode.string)
        (Decode.field "image" (Decode.nullable Decode.string))
