module JsonTest exposing (..)

import Expect
import Json exposing (decodePresentation, encodePresentation)
import Json.Decode as Decode
import Test exposing (..)
import Types exposing (SlideLayout(..))


suite : Test
suite =
    describe "JSON Encoders and Decoders"
        [ describe "SlideLayout encoding and decoding"
            [ test "JustMarkdown round-trip" <|
                \_ ->
                    let
                        slide =
                            { content = "# Test"
                            , layout = JustMarkdown
                            , image = Nothing
                            }

                        presentation =
                            { slides = [ slide ]
                            , title = "Test"
                            , author = "Author"
                            , created = "2025-01-01"
                            }

                        encoded =
                            encodePresentation presentation

                        decoded =
                            Decode.decodeValue decodePresentation encoded
                    in
                    case decoded of
                        Ok result ->
                            Expect.equal result presentation

                        Err err ->
                            Expect.fail (Decode.errorToString err)
            , test "MarkdownWithImage round-trip" <|
                \_ ->
                    let
                        slide =
                            { content = "# Test with image"
                            , layout = MarkdownWithImage
                            , image = Just "data:image/png;base64,test"
                            }

                        presentation =
                            { slides = [ slide ]
                            , title = "Test"
                            , author = "Author"
                            , created = "2025-01-01"
                            }

                        encoded =
                            encodePresentation presentation

                        decoded =
                            Decode.decodeValue decodePresentation encoded
                    in
                    case decoded of
                        Ok result ->
                            Expect.equal result presentation

                        Err err ->
                            Expect.fail (Decode.errorToString err)
            ]
        , describe "Slide encoding and decoding"
            [ test "Slide with no image" <|
                \_ ->
                    let
                        slide =
                            { content = "Some content"
                            , layout = JustMarkdown
                            , image = Nothing
                            }

                        presentation =
                            { slides = [ slide ]
                            , title = "Test"
                            , author = "Author"
                            , created = "2025-01-01"
                            }

                        encoded =
                            encodePresentation presentation

                        decoded =
                            Decode.decodeValue decodePresentation encoded
                    in
                    case decoded of
                        Ok result ->
                            Expect.equal result.slides [ slide ]

                        Err err ->
                            Expect.fail (Decode.errorToString err)
            , test "Slide with image" <|
                \_ ->
                    let
                        slide =
                            { content = "Image slide"
                            , layout = MarkdownWithImage
                            , image = Just "data:image/jpeg;base64,/9j/4AAQ"
                            }

                        presentation =
                            { slides = [ slide ]
                            , title = "Test"
                            , author = "Author"
                            , created = "2025-01-01"
                            }

                        encoded =
                            encodePresentation presentation

                        decoded =
                            Decode.decodeValue decodePresentation encoded
                    in
                    case decoded of
                        Ok result ->
                            Expect.equal result.slides [ slide ]

                        Err err ->
                            Expect.fail (Decode.errorToString err)
            ]
        , describe "Presentation encoding and decoding"
            [ test "Empty presentation" <|
                \_ ->
                    let
                        presentation =
                            { slides = []
                            , title = "Empty"
                            , author = "Nobody"
                            , created = "2025-01-01"
                            }

                        encoded =
                            encodePresentation presentation

                        decoded =
                            Decode.decodeValue decodePresentation encoded
                    in
                    case decoded of
                        Ok result ->
                            Expect.equal result presentation

                        Err err ->
                            Expect.fail (Decode.errorToString err)
            , test "Multiple slides presentation" <|
                \_ ->
                    let
                        presentation =
                            { slides =
                                [ { content = "# First slide", layout = JustMarkdown, image = Nothing }
                                , { content = "# Second slide\nWith content", layout = MarkdownWithImage, image = Just "data:image/png;base64,abc" }
                                , { content = "Third slide", layout = JustMarkdown, image = Nothing }
                                ]
                            , title = "Multi-slide presentation"
                            , author = "Test Author"
                            , created = "2025-12-16"
                            }

                        encoded =
                            encodePresentation presentation

                        decoded =
                            Decode.decodeValue decodePresentation encoded
                    in
                    case decoded of
                        Ok result ->
                            Expect.equal result presentation

                        Err err ->
                            Expect.fail (Decode.errorToString err)
            , test "Presentation metadata preserved" <|
                \_ ->
                    let
                        presentation =
                            { slides = []
                            , title = "Special Title with émojis 🎉"
                            , author = "Auteur Spécial"
                            , created = "2025-12-16T12:34:56Z"
                            }

                        encoded =
                            encodePresentation presentation

                        decoded =
                            Decode.decodeValue decodePresentation encoded
                    in
                    case decoded of
                        Ok result ->
                            Expect.all
                                [ \_ -> Expect.equal result.title presentation.title
                                , \_ -> Expect.equal result.author presentation.author
                                , \_ -> Expect.equal result.created presentation.created
                                ]
                                ()

                        Err err ->
                            Expect.fail (Decode.errorToString err)
            ]
        , describe "Legacy format compatibility"
            [ test "Can decode old title-only layout" <|
                \_ ->
                    let
                        -- Simulate old format JSON
                        jsonString =
                            """
                            {
                                "slides": [
                                    {
                                        "content": "# Old Format",
                                        "layout": "title-only",
                                        "image": null
                                    }
                                ],
                                "title": "Legacy",
                                "author": "Old",
                                "created": "2020-01-01"
                            }
                            """

                        decoded =
                            Decode.decodeString decodePresentation jsonString
                    in
                    case decoded of
                        Ok result ->
                            case List.head result.slides of
                                Just slide ->
                                    -- Old title-only should be converted to JustMarkdown
                                    Expect.equal slide.layout JustMarkdown

                                Nothing ->
                                    Expect.fail "Expected at least one slide"

                        Err err ->
                            Expect.fail (Decode.errorToString err)
            ]
        ]
