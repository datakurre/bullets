module Main exposing (main)

import Browser
import File exposing (File)
import File.Download as Download
import File.Select as Select
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Json as AppJson
import Json.Decode as Decode
import Json.Encode as Encode
import Task
import Types exposing (Mode(..), Model, Msg(..), Presentation, Slide, SlideLayout(..), initialModel)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NextSlide ->
            let
                maxIndex =
                    List.length model.presentation.slides - 1

                newIndex =
                    min maxIndex (model.currentSlideIndex + 1)
            in
            ( { model | currentSlideIndex = newIndex }, Cmd.none )

        PrevSlide ->
            let
                newIndex =
                    max 0 (model.currentSlideIndex - 1)
            in
            ( { model | currentSlideIndex = newIndex }, Cmd.none )

        GoToSlide index ->
            ( { model | currentSlideIndex = index }, Cmd.none )

        EnterPresentMode ->
            ( { model | mode = Present }, Cmd.none )

        ExitPresentMode ->
            ( { model | mode = Edit }, Cmd.none )

        AddSlide ->
            let
                newSlide =
                    { content = "# New Slide"
                    , layout = JustMarkdown
                    , image = Nothing
                    }

                presentation =
                    model.presentation

                updatedPresentation =
                    { presentation | slides = presentation.slides ++ [ newSlide ] }

                newIndex =
                    List.length updatedPresentation.slides - 1
            in
            ( { model
                | presentation = updatedPresentation
                , currentSlideIndex = newIndex
                , editingContent = newSlide.content
              }
            , Cmd.none
            )

        DeleteSlide index ->
            let
                presentation =
                    model.presentation

                updatedSlides =
                    List.indexedMap Tuple.pair presentation.slides
                        |> List.filter (\( i, _ ) -> i /= index)
                        |> List.map Tuple.second

                updatedPresentation =
                    { presentation | slides = updatedSlides }

                newIndex =
                    min (List.length updatedSlides - 1) model.currentSlideIndex
                        |> max 0
            in
            if List.length presentation.slides <= 1 then
                ( model, Cmd.none )

            else
                ( { model
                    | presentation = updatedPresentation
                    , currentSlideIndex = newIndex
                  }
                , Cmd.none
                )

        DuplicateSlide index ->
            let
                presentation =
                    model.presentation

                maybeSlide =
                    List.drop index presentation.slides
                        |> List.head

                updatedSlides =
                    case maybeSlide of
                        Just slide ->
                            let
                                before =
                                    List.take (index + 1) presentation.slides

                                after =
                                    List.drop (index + 1) presentation.slides
                            in
                            before ++ [ slide ] ++ after

                        Nothing ->
                            presentation.slides

                updatedPresentation =
                    { presentation | slides = updatedSlides }
            in
            ( { model | presentation = updatedPresentation }, Cmd.none )

        MoveSlideUp index ->
            if index <= 0 then
                ( model, Cmd.none )

            else
                let
                    presentation =
                        model.presentation

                    updatedSlides =
                        swapSlides (index - 1) index presentation.slides

                    updatedPresentation =
                        { presentation | slides = updatedSlides }

                    newIndex =
                        if model.currentSlideIndex == index then
                            index - 1

                        else if model.currentSlideIndex == index - 1 then
                            index

                        else
                            model.currentSlideIndex
                in
                ( { model
                    | presentation = updatedPresentation
                    , currentSlideIndex = newIndex
                  }
                , Cmd.none
                )

        MoveSlideDown index ->
            let
                presentation =
                    model.presentation

                maxIndex =
                    List.length presentation.slides - 1
            in
            if index >= maxIndex then
                ( model, Cmd.none )

            else
                let
                    updatedSlides =
                        swapSlides index (index + 1) presentation.slides

                    updatedPresentation =
                        { presentation | slides = updatedSlides }

                    newIndex =
                        if model.currentSlideIndex == index then
                            index + 1

                        else if model.currentSlideIndex == index + 1 then
                            index

                        else
                            model.currentSlideIndex
                in
                ( { model
                    | presentation = updatedPresentation
                    , currentSlideIndex = newIndex
                  }
                , Cmd.none
                )

        UpdateContent content ->
            let
                presentation =
                    model.presentation

                updatedSlides =
                    List.indexedMap
                        (\i slide ->
                            if i == model.currentSlideIndex then
                                { slide | content = content }

                            else
                                slide
                        )
                        presentation.slides

                updatedPresentation =
                    { presentation | slides = updatedSlides }
            in
            ( { model
                | editingContent = content
                , presentation = updatedPresentation
              }
            , Cmd.none
            )

        ChangeLayout layout ->
            let
                presentation =
                    model.presentation

                updatedSlides =
                    List.indexedMap
                        (\i slide ->
                            if i == model.currentSlideIndex then
                                { slide | layout = layout }

                            else
                                slide
                        )
                        presentation.slides

                updatedPresentation =
                    { presentation | slides = updatedSlides }
            in
            ( { model | presentation = updatedPresentation }, Cmd.none )

        ImagePasted dataUri ->
            let
                presentation =
                    model.presentation

                updatedSlides =
                    List.indexedMap
                        (\i slide ->
                            if i == model.currentSlideIndex then
                                { slide | image = Just dataUri }

                            else
                                slide
                        )
                        presentation.slides

                updatedPresentation =
                    { presentation | slides = updatedSlides }
            in
            ( { model | presentation = updatedPresentation }, Cmd.none )

        RemoveImage ->
            let
                presentation =
                    model.presentation

                updatedSlides =
                    List.indexedMap
                        (\i slide ->
                            if i == model.currentSlideIndex then
                                { slide | image = Nothing }

                            else
                                slide
                        )
                        presentation.slides

                updatedPresentation =
                    { presentation | slides = updatedSlides }
            in
            ( { model | presentation = updatedPresentation }, Cmd.none )

        DownloadJSON ->
            let
                json =
                    AppJson.encodePresentation model.presentation

                jsonString =
                    Encode.encode 2 json

                filename =
                    model.presentation.title ++ ".json"
            in
            ( model, Download.string filename "application/json" jsonString )

        LoadJSONRequested ->
            ( model, Select.file [ "application/json" ] FileSelected )

        FileSelected file ->
            ( model, Task.perform FileLoaded (File.toString file) )

        FileLoaded content ->
            case Decode.decodeString AppJson.decodePresentation content of
                Ok presentation ->
                    let
                        firstSlideContent =
                            List.head presentation.slides
                                |> Maybe.map .content
                                |> Maybe.withDefault ""
                    in
                    ( { model
                        | presentation = presentation
                        , currentSlideIndex = 0
                        , editingContent = firstSlideContent
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( model, Cmd.none )


swapSlides : Int -> Int -> List Slide -> List Slide
swapSlides i j slides =
    let
        indexed =
            List.indexedMap Tuple.pair slides

        maybeA =
            List.filter (\( idx, _ ) -> idx == i) indexed
                |> List.head
                |> Maybe.map Tuple.second

        maybeB =
            List.filter (\( idx, _ ) -> idx == j) indexed
                |> List.head
                |> Maybe.map Tuple.second
    in
    case ( maybeA, maybeB ) of
        ( Just a, Just b ) ->
            List.indexedMap
                (\idx slide ->
                    if idx == i then
                        b

                    else if idx == j then
                        a

                    else
                        slide
                )
                slides

        _ ->
            slides



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ case model.mode of
            Edit ->
                viewEditMode model

            Present ->
                viewPresentMode model
        ]


viewEditMode : Model -> Html Msg
viewEditMode model =
    div [ class "edit-mode" ]
        [ text "Edit Mode - Coming Soon"
        , button [ onClick EnterPresentMode ] [ text "Present" ]
        , button [ onClick AddSlide ] [ text "Add Slide" ]
        , button [ onClick DownloadJSON ] [ text "Download JSON" ]
        , button [ onClick LoadJSONRequested ] [ text "Load JSON" ]
        ]


viewPresentMode : Model -> Html Msg
viewPresentMode model =
    div [ class "present-mode" ]
        [ text "Present Mode - Coming Soon"
        , button [ onClick ExitPresentMode ] [ text "Exit" ]
        , button [ onClick PrevSlide ] [ text "Previous" ]
        , button [ onClick NextSlide ] [ text "Next" ]
        ]
