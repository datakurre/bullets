module View.Edit exposing (viewEditMode)

import Html exposing (Html, button, div, h3, img, span, text, textarea)
import Html.Attributes exposing (class, draggable, placeholder, src, value)
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
    div [ class "sidebar" ]
        [ div [ class "sidebar-header" ]
            [ h3 [] [ text "Slides" ]
            , button [ onClick AddSlide, class "btn-add" ] [ text "+" ]
            ]
        , div [ class "slide-list" ]
            (List.indexedMap (viewSlideItem model) model.presentation.slides)
        , div [ class "sidebar-footer" ]
            [ button [ onClick EnterPresentMode, class "btn-present" ] [ text "▶ Present" ]
            , button [ onClick ImportPPTXRequested, class "btn-import-pptx" ] [ text "📥 Import PPTX" ]
            , button [ onClick ExportToPPTX, class "btn-export" ] [ text "📊 Export PPTX" ]
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
            , div [ class "slide-item-actions" ]
                [ button [ onClick (MoveSlideUp index), class "btn-icon" ] [ text "↑" ]
                , button [ onClick (MoveSlideDown index), class "btn-icon" ] [ text "↓" ]
                , button [ onClick (DuplicateSlide index), class "btn-icon" ] [ text "⎘" ]
                , button [ onClick (DeleteSlide index), class "btn-icon btn-danger" ] [ text "×" ]
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
        [ div [ class "image-controls" ]
            [ if slide.image /= Nothing then
                button [ onClick RemoveImage, class "btn-remove-image" ] [ text "Remove Image" ]

              else
                button [ onClick ImageUploadRequested, class "btn-upload-image" ] [ text "📁 Upload Image" ]
            ]
        ]


viewEditorMain : Slide -> Html Msg
viewEditorMain slide =
    div [ class "editor-main" ]
        [ textarea
            [ class "editor-textarea"
            , value slide.content
            , onInput UpdateContent
            , onFocus TextareaFocused
            , onBlur TextareaBlurred
            , placeholder "Enter markdown content..."
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
    div [ class "editor-preview" ]
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
