module View.Edit exposing (viewEditMode)

import Html exposing (Html, button, div, h3, img, option, select, span, text, textarea)
import Html.Attributes exposing (class, placeholder, selected, src, value)
import Html.Events exposing (onClick, onInput)
import MarkdownView exposing (renderMarkdown)
import Types exposing (Model, Msg(..), Slide, SlideLayout(..))


viewEditMode : Model -> Html Msg
viewEditMode model =
    div [ class "edit-mode" ]
        [ viewSidebar model
        , viewEditor model
        ]


viewSidebar : Model -> Html Msg
viewSidebar model =
    div [ class "sidebar" ]
        [ div [ class "sidebar-header" ]
            [ h3 [] [ text "Slides" ]
            , button [ onClick AddSlide, class "btn-add" ] [ text "+" ]
            ]
        , div [ class "slide-list" ]
            (List.indexedMap (viewSlideItem model.currentSlideIndex) model.presentation.slides)
        , div [ class "sidebar-footer" ]
            [ button [ onClick EnterPresentMode, class "btn-present" ] [ text "▶ Present" ]
            , button [ onClick LoadJSONRequested, class "btn-load" ] [ text "📁 Load" ]
            , button [ onClick DownloadJSON, class "btn-save" ] [ text "💾 Save" ]
            ]
        ]


viewSlideItem : Int -> Int -> Slide -> Html Msg
viewSlideItem currentIndex index slide =
    let
        isActive =
            index == currentIndex

        firstLine =
            String.lines slide.content
                |> List.head
                |> Maybe.withDefault "Empty slide"
                |> String.left 30
    in
    div
        [ class
            (if isActive then
                "slide-item active"

             else
                "slide-item"
            )
        , onClick (GoToSlide index)
        ]
        [ div [ class "slide-item-content" ]
            [ span [ class "slide-number" ] [ text (String.fromInt (index + 1)) ]
            , span [ class "slide-preview" ] [ text firstLine ]
            ]
        , div [ class "slide-item-actions" ]
            [ button [ onClick (MoveSlideUp index), class "btn-icon" ] [ text "↑" ]
            , button [ onClick (MoveSlideDown index), class "btn-icon" ] [ text "↓" ]
            , button [ onClick (DuplicateSlide index), class "btn-icon" ] [ text "⎘" ]
            , button [ onClick (DeleteSlide index), class "btn-icon btn-danger" ] [ text "×" ]
            ]
        ]


viewEditor : Model -> Html Msg
viewEditor model =
    let
        currentSlide =
            List.drop model.currentSlideIndex model.presentation.slides
                |> List.head
    in
    case currentSlide of
        Just slide ->
            div [ class "editor" ]
                [ viewEditorToolbar slide
                , viewEditorMain slide
                , viewEditorPreview slide
                ]

        Nothing ->
            div [ class "editor" ]
                [ text "No slide selected" ]


viewEditorToolbar : Slide -> Html Msg
viewEditorToolbar slide =
    div [ class "editor-toolbar" ]
        [ div [ class "layout-selector" ]
            [ text "Layout: "
            , select [ onInput layoutFromString ]
                [ option [ value "just-markdown", selected (slide.layout == JustMarkdown) ] [ text "Markdown" ]
                , option [ value "markdown-with-image", selected (slide.layout == MarkdownWithImage) ] [ text "Markdown + Image" ]
                ]
            ]
        , if slide.layout == MarkdownWithImage then
            div [ class "image-controls" ]
                [ if slide.image /= Nothing then
                    button [ onClick RemoveImage, class "btn-remove-image" ] [ text "Remove Image" ]

                  else
                    button [ onClick ImageUploadRequested, class "btn-upload-image" ] [ text "📁 Upload Image" ]
                ]

          else
            text ""
        ]


layoutFromString : String -> Msg
layoutFromString str =
    case str of
        "just-markdown" ->
            ChangeLayout JustMarkdown

        "markdown-with-image" ->
            ChangeLayout MarkdownWithImage

        _ ->
            ChangeLayout JustMarkdown


viewEditorMain : Slide -> Html Msg
viewEditorMain slide =
    div [ class "editor-main" ]
        [ textarea
            [ class "editor-textarea"
            , value slide.content
            , onInput UpdateContent
            , placeholder "Enter markdown content..."
            ]
            []
        ]


viewEditorPreview : Slide -> Html Msg
viewEditorPreview slide =
    let
        isOnlyTitle =
            isTitleOnly slide.content
    in
    div [ class "editor-preview" ]
        [ div [ class ("preview-" ++ layoutClass slide.layout ++ if isOnlyTitle then " preview-title-centered" else "") ]
            [ case slide.layout of
                JustMarkdown ->
                    div [ class (if isOnlyTitle then "preview-title" else "preview-markdown") ]
                        [ renderMarkdown slide.content ]

                MarkdownWithImage ->
                    div [ class "preview-split" ]
                        [ div [ class "preview-markdown" ]
                            [ renderMarkdown slide.content ]
                        , div [ class "preview-image" ]
                            [ case slide.image of
                                Just dataUri ->
                                    img [ src dataUri ] []

                                Nothing ->
                                    div [ class "image-placeholder" ] [ text "Paste an image here" ]
                            ]
                        ]
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


layoutClass : SlideLayout -> String
layoutClass layout =
    case layout of
        JustMarkdown ->
            "markdown"

        MarkdownWithImage ->
            "split"
