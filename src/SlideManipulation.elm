module SlideManipulation exposing
    ( addSlide
    , deleteSlide
    , duplicateSlide
    , moveSlideUp
    , moveSlideDown
    , swapSlides
    )

import Types exposing (Slide, SlideLayout(..))


{-| Add a new slide to the end of the slides list
-}
addSlide : List Slide -> List Slide
addSlide slides =
    let
        newSlide =
            { content = "# New Slide"
            , layout = JustMarkdown
            , image = Nothing
            }
    in
    slides ++ [ newSlide ]


{-| Delete a slide at the given index. Returns the original list if:
- The index is out of bounds
- There's only one slide remaining (must have at least one slide)
-}
deleteSlide : Int -> List Slide -> List Slide
deleteSlide index slides =
    if List.length slides <= 1 then
        slides

    else
        List.indexedMap Tuple.pair slides
            |> List.filter (\( i, _ ) -> i /= index)
            |> List.map Tuple.second


{-| Duplicate a slide at the given index, inserting the copy immediately after.
Returns the original list if the index is out of bounds.
-}
duplicateSlide : Int -> List Slide -> List Slide
duplicateSlide index slides =
    let
        maybeSlide =
            List.drop index slides
                |> List.head
    in
    case maybeSlide of
        Just slide ->
            let
                before =
                    List.take (index + 1) slides

                after =
                    List.drop (index + 1) slides
            in
            before ++ [ slide ] ++ after

        Nothing ->
            slides


{-| Move a slide up one position (swap with the previous slide).
Returns the original list if the index is 0 or out of bounds.
-}
moveSlideUp : Int -> List Slide -> List Slide
moveSlideUp index slides =
    if index <= 0 then
        slides

    else
        swapSlides (index - 1) index slides


{-| Move a slide down one position (swap with the next slide).
Returns the original list if the index is at the end or out of bounds.
-}
moveSlideDown : Int -> List Slide -> List Slide
moveSlideDown index slides =
    let
        maxIndex =
            List.length slides - 1
    in
    if index >= maxIndex then
        slides

    else
        swapSlides index (index + 1) slides


{-| Swap two slides at the given indices.
Returns the original list if either index is out of bounds.
-}
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
