module Json exposing (decodePresentation, encodePresentation)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Types exposing (Presentation, Slide, SlideLayout(..))



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
    Encode.object
        [ ( "content", Encode.string slide.content )
        , ( "layout", encodeSlideLayout slide.layout )
        , ( "image"
          , case slide.image of
                Just img ->
                    Encode.string img

                Nothing ->
                    Encode.null
          )
        ]


encodeSlideLayout : SlideLayout -> Encode.Value
encodeSlideLayout layout =
    case layout of
        JustMarkdown ->
            Encode.string "just-markdown"

        MarkdownWithImage ->
            Encode.string "markdown-with-image"



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
    Decode.map3 Slide
        (Decode.field "content" Decode.string)
        (Decode.field "layout" decodeSlideLayout)
        (Decode.field "image" (Decode.nullable Decode.string))


decodeSlideLayout : Decoder SlideLayout
decodeSlideLayout =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "title-only" ->
                        -- Legacy format, convert to JustMarkdown
                        Decode.succeed JustMarkdown

                    "just-markdown" ->
                        Decode.succeed JustMarkdown

                    "markdown-with-image" ->
                        Decode.succeed MarkdownWithImage

                    _ ->
                        Decode.fail ("Unknown layout: " ++ str)
            )
