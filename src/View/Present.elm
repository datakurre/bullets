module View.Present exposing (viewPresentMode)

import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import MarkdownView exposing (renderMarkdown)
import Types exposing (Model, Msg(..), Slide)


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
    let
        isOnlyTitle =
            isTitleOnly slide.content
        
        isCoverStyle =
            isCoverSlide slide.content
        
        hasContent =
            not (String.isEmpty (String.trim slide.content))
        
        hasImage =
            slide.image /= Nothing
    in
    div [ class ("slide slide-" ++ (if hasImage then "markdown-with-image" else "just-markdown") ++ if isOnlyTitle then " slide-title-centered" else if isCoverStyle then " slide-cover" else "") ]
        [ if hasImage then
            if not hasContent && slide.image /= Nothing then
                -- Image only, take full slide
                div [ class "slide-image-full" ]
                    [ case slide.image of
                        Just dataUri ->
                            img [ src dataUri, class "slide-image-fullscreen" ] []

                        Nothing ->
                            text ""
                    ]
            else
                -- Normal split layout
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
          else
            -- No image, just markdown
            div [ class (if isOnlyTitle then "slide-title" else "slide-markdown") ]
                [ div [ class (if isOnlyTitle then "title-content" else "markdown-content") ]
                    [ renderMarkdown slide.content ]
                ]
        ]


isTitleOnly : String -> Bool
isTitleOnly content =
    let
        trimmed =
            String.trim content
        
        lines =
            String.lines trimmed
    in
    case lines of
        [singleLine] ->
            String.startsWith "#" singleLine
        
        _ ->
            False


isCoverSlide : String -> Bool
isCoverSlide content =
    let
        trimmed =
            String.trim content
        
        lines =
            String.lines trimmed
                |> List.filter (\line -> not (String.isEmpty (String.trim line)))
    in
    case lines of
        firstLine :: rest ->
            -- Check if first line is a heading and there's more content
            String.startsWith "#" firstLine && not (List.isEmpty rest)
        
        _ ->
            False


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
