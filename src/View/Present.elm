module View.Present exposing (viewPresentMode)

import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import MarkdownView exposing (renderMarkdown)
import Types exposing (Model, Msg(..), Slide, SlideLayout(..))


viewPresentMode : Model -> Html Msg
viewPresentMode model =
    let
        currentSlide =
            List.drop model.currentSlideIndex model.presentation.slides
                |> List.head

        totalSlides =
            List.length model.presentation.slides
    in
    case currentSlide of
        Just slide ->
            div [ class "present-mode" ]
                [ viewSlide slide
                , viewPresentControls model.currentSlideIndex totalSlides
                ]

        Nothing ->
            div [ class "present-mode" ]
                [ text "No slide to display" ]


viewSlide : Slide -> Html Msg
viewSlide slide =
    div [ class ("slide slide-" ++ layoutClass slide.layout) ]
        [ case slide.layout of
            TitleOnly ->
                div [ class "slide-title" ]
                    [ div [ class "title-content" ]
                        [ renderMarkdown slide.content ]
                    ]

            JustMarkdown ->
                div [ class "slide-markdown" ]
                    [ div [ class "markdown-content" ]
                        [ renderMarkdown slide.content ]
                    ]

            MarkdownWithImage ->
                div [ class "slide-split" ]
                    [ div [ class "slide-markdown-left" ]
                        [ div [ class "markdown-content" ]
                            [ renderMarkdown slide.content ]
                        ]
                    , div [ class "slide-image-right" ]
                        [ case slide.image of
                            Just dataUri ->
                                img [ src dataUri, class "slide-image" ] []

                            Nothing ->
                                text ""
                        ]
                    ]
        ]


viewPresentControls : Int -> Int -> Html Msg
viewPresentControls currentIndex totalSlides =
    div [ class "present-controls" ]
        [ button [ onClick ExitPresentMode, class "btn-exit" ] [ text "✕" ]
        , div [ class "slide-counter" ]
            [ text (String.fromInt (currentIndex + 1) ++ " / " ++ String.fromInt totalSlides) ]
        , div [ class "nav-buttons" ]
            [ button [ onClick PrevSlide, class "btn-nav" ] [ text "‹" ]
            , button [ onClick NextSlide, class "btn-nav" ] [ text "›" ]
            ]
        ]


layoutClass : SlideLayout -> String
layoutClass layout =
    case layout of
        TitleOnly ->
            "title"

        JustMarkdown ->
            "markdown"

        MarkdownWithImage ->
            "split"
