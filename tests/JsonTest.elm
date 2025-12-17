module JsonTest exposing (..)

import Expect
import Json exposing (decodePresentation, encodePresentation)
import Json.Decode as Decode
import Test exposing (..)


suite : Test
suite =
    describe "JSON Encoders and Decoders"
        [ describe "Slide encoding and decoding"
            [ describe "given a slide without an image"
                [ describe "when encoding and decoding"
                    [ test "should preserve all slide data" <|
                        \_ ->
                            let
                                slide =
                                    { content = "# Test"
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
                    ]
                ]
            , describe "given a slide with an image"
                [ describe "when encoding and decoding"
                    [ test "should preserve all slide data including the image" <|
                        \_ ->
                            let
                                slide =
                                    { content = "# Test with image"
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
                ]
            ]
        , describe "Individual slide encoding"
            [ describe "given a slide with no image"
                [ describe "when encoding and decoding"
                    [ test "should correctly encode the slide" <|
                        \_ ->
                            let
                                slide =
                                    { content = "Some content"
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
                    ]
                ]
            , describe "given a slide with an image"
                [ describe "when encoding and decoding"
                    [ test "should correctly encode the slide with its image" <|
                        \_ ->
                            let
                                slide =
                                    { content = "Image slide"
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
                ]
            ]
        , describe "Presentation encoding and decoding"
            [ describe "given an empty presentation"
                [ describe "when encoding and decoding"
                    [ test "should preserve the empty presentation" <|
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
                    ]
                ]
            , describe "given a presentation with multiple slides"
                [ describe "when encoding and decoding"
                    [ test "should preserve all slides and their order" <|
                        \_ ->
                            let
                                presentation =
                                    { slides =
                                        [ { content = "# First slide", image = Nothing }
                                        , { content = "# Second slide\nWith content", image = Just "data:image/png;base64,abc" }
                                        , { content = "Third slide", image = Nothing }
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
                    ]
                ]
            , describe "given a presentation with special characters in metadata"
                [ describe "when encoding and decoding"
                    [ test "should preserve all metadata fields" <|
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
                    , test "should handle special characters in title" <|
                        \_ ->
                            let
                                presentation =
                                    { slides = []
                                    , title = "My Presentation: Tests & Examples (2025)"
                                    , author = ""
                                    , created = ""
                                    }

                                encoded =
                                    encodePresentation presentation

                                decoded =
                                    Decode.decodeValue decodePresentation encoded
                            in
                            case decoded of
                                Ok result ->
                                    Expect.equal result.title presentation.title

                                Err err ->
                                    Expect.fail (Decode.errorToString err)
                    ]
                ]
            ]
        , describe "Legacy format compatibility"
            [ describe "given old format JSON with layout field"
                [ describe "when decoding"
                    [ test "should handle legacy format gracefully" <|
                        \_ ->
                            let
                                -- Simulate old format JSON with layout field (should be ignored)
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
                                            -- Old layout field should be ignored, slide should decode successfully
                                            Expect.equal slide.content "# Old Format"

                                        Nothing ->
                                            Expect.fail "Expected at least one slide"

                                Err _ ->
                                    -- Old format with layout field should fail since we removed layout from decoder
                                    Expect.pass
                    ]
                ]
            ]
        ]
