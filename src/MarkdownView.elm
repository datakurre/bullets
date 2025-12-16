module MarkdownView exposing (renderMarkdown)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Markdown.Parser
import Markdown.Renderer


{-| Render markdown string to HTML, falling back to error message if parsing fails
-}
renderMarkdown : String -> Html msg
renderMarkdown markdown =
    case
        markdown
            |> Markdown.Parser.parse
            |> Result.mapError (\_ -> "Failed to parse markdown")
            |> Result.andThen (\ast -> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer ast)
    of
        Ok rendered ->
            div [] rendered

        Err error ->
            div [ style "color" "red" ] [ text ("Markdown error: " ++ error) ]
