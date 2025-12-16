module View.Edit exposing (viewEditMode)

import Html exposing (Html, aside, button, div, h3, img, main_, nav, span, text, textarea)
import Html.Attributes exposing (attribute, class, draggable, placeholder, src, value)
import Html.Events exposing (on, onBlur, onClick, onFocus, onInput, preventDefaultOn)
import Json.Decode as Decode
import MarkdownView exposing (renderMarkdown)
import Types exposing (Model, Msg(..), Slide)


viewEditMode : Model -> Html Msg
viewEditMode model =
    div [ class "edit-mode" ]
        [ viewSidebar model
        , viewEditor model
        ]


viewSidebar : Model -> Html Msg
viewSidebar model =
    aside [ class "sidebar", attribute "role" "complementary", attribute "aria-label" "Slide navigation" ]
        [ div [ class "sidebar-header" ]
            [ h3 [] [ text "Slides" ]
            , button [ onClick AddSlide, class "btn-add", attribute "aria-label" "Add new slide" ] [ text "+" ]
            ]
        , nav [ attribute "aria-label" "Slide list" ]
            [ div [ class "slide-list", attribute "role" "list" ]
                (List.indexedMap (viewSlideItem model) model.presentation.slides)
            ]
        , div [ class "sidebar-footer" ]
            [ button [ onClick EnterPresentMode, class "btn-present", attribute "aria-label" "Enter presentation mode" ]
                [ span [ class "btn-icon-emoji" ] [ text "▶" ]
                , span [ class "btn-label" ] [ text "Present" ]
                ]
            , button [ onClick ImportPPTXRequested, class "btn-import-pptx", attribute "aria-label" "Import PowerPoint PPTX file" ]
                [ span [ class "btn-icon-emoji" ] [ text "📥" ]
                , span [ class "btn-label" ] [ text "Import PPTX" ]
                ]
            , button [ onClick ExportToPPTX, class "btn-export", attribute "aria-label" "Export to PowerPoint PPTX" ]
                [ span [ class "btn-icon-emoji" ] [ text "📊" ]
                , span [ class "btn-label" ] [ text "Export PPTX" ]
                ]
            ]
        ]


viewSlideItem : Model -> Int -> Slide -> Html Msg
viewSlideItem model index slide =
    let
        isActive =
            index == model.currentSlideIndex

        isDragging =
            model.draggedSlideIndex == Just index

        showPlaceholder =
            model.dropTargetIndex == Just index && not isDragging

        firstLine =
            String.lines slide.content
                |> List.head
                |> Maybe.withDefault "Empty slide"
                |> String.left 30

        className =
            String.join " "
                [ "slide-item"
                , if isActive then
                    "active"

                  else
                    ""
                , if isDragging then
                    "dragging"

                  else
                    ""
                ]
    in
    div []
        [ if showPlaceholder then
            div [ class "drop-placeholder" ] []

          else
            text ""
        , div
            [ class className
            , onClick (GoToSlide index)
            , draggable "true"
            , on "dragstart" (Decode.succeed (DragStart index))
            , on "dragend" (Decode.succeed DragEnd)
            , preventDefaultOn "dragover" (Decode.succeed ( DragOver index, True ))
            , on "drop" (Decode.succeed (Drop index))
            , attribute "role" "listitem"
            , if isActive then
                attribute "aria-current" "true"

              else
                attribute "aria-current" "false"
            ]
            [ div [ class "slide-item-content" ]
                [ span [ class "slide-number" ] [ text (String.fromInt (index + 1)) ]
                , span [ class "slide-preview" ] [ text firstLine ]
                , case slide.image of
                    Just imageData ->
                        img [ class "slide-thumbnail", src imageData ] []

                    Nothing ->
                        text ""
                ]
            , div [ class "slide-item-actions", attribute "role" "toolbar", attribute "aria-label" "Slide actions" ]
                [ button [ onClick (MoveSlideUp index), class "btn-icon", attribute "aria-label" "Move slide up" ] [ text "↑" ]
                , button [ onClick (MoveSlideDown index), class "btn-icon", attribute "aria-label" "Move slide down" ] [ text "↓" ]
                , button [ onClick (DuplicateSlide index), class "btn-icon", attribute "aria-label" "Duplicate slide" ] [ text "⎘" ]
                , button [ onClick (DeleteSlide index), class "btn-icon btn-danger", attribute "aria-label" "Delete slide" ] [ text "×" ]
                ]
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
            main_ [ class "editor", attribute "role" "main", attribute "aria-label" "Slide editor" ]
                [ viewEditorToolbar slide
                , viewEditorMain slide
                , viewEditorPreview slide
                ]

        Nothing ->
            main_ [ class "editor" ]
                [ text "No slide selected" ]


viewEditorToolbar : Slide -> Html Msg
viewEditorToolbar slide =
    div [ class "editor-toolbar", attribute "role" "region", attribute "aria-label" "Image controls" ]
        [ div [ class "image-controls" ]
            [ if slide.image /= Nothing then
                button [ onClick RemoveImage, class "btn-remove-image", attribute "aria-label" "Remove current image from slide" ] [ text "Remove Image" ]

              else
                button [ onClick ImageUploadRequested, class "btn-upload-image", attribute "aria-label" "Upload image file" ] [ text "📁 Upload Image" ]
            ]
        ]


viewEditorMain : Slide -> Html Msg
viewEditorMain slide =
    div [ class "editor-main", attribute "role" "region", attribute "aria-label" "Content editor" ]
        [ textarea
            [ class "editor-textarea"
            , value slide.content
            , onInput UpdateContent
            , onFocus TextareaFocused
            , onBlur TextareaBlurred
            , placeholder "Enter markdown content..."
            , attribute "aria-label" "Slide content editor"
            ]
            []
        ]


viewEditorPreview : Slide -> Html Msg
viewEditorPreview slide =
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
    div [ class "editor-preview", attribute "role" "region", attribute "aria-label" "Slide preview" ]
        [ div
            [ class
                ("preview-slide preview-"
                    ++ (if hasImage then
                            "markdown-with-image"

                        else
                            "just-markdown"
                       )
                    ++ (if isOnlyTitle then
                            " preview-title-centered"

                        else if isCoverStyle then
                            " preview-cover"

                        else
                            ""
                       )
                )
            ]
            [ if hasImage then
                if not hasContent && slide.image /= Nothing then
                    -- Image only, take full slide
                    div [ class "preview-image-full" ]
                        [ case slide.image of
                            Just dataUri ->
                                img [ src dataUri, class "preview-image-fullscreen" ] []

                            Nothing ->
                                text ""
                        ]

                else
                    -- Normal split layout
                    div [ class "preview-split" ]
                        [ div [ class "preview-markdown-left" ]
                            [ div [ class "markdown-content" ]
                                [ renderMarkdown slide.content ]
                            ]
                        , div [ class "preview-image-right" ]
                            [ case slide.image of
                                Just dataUri ->
                                    img [ src dataUri, class "preview-image" ] []

                                Nothing ->
                                    div [ class "image-placeholder" ] [ text "Paste an image here" ]
                            ]
                        ]

              else
                -- No image, just markdown
                div
                    [ class
                        (if isOnlyTitle then
                            "preview-title"

                         else
                            "preview-markdown"
                        )
                    ]
                    [ div
                        [ class
                            (if isOnlyTitle then
                                "title-content"

                             else
                                "markdown-content"
                            )
                        ]
                        [ renderMarkdown slide.content ]
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
        [ singleLine ] ->
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
