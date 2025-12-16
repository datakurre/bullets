module Navigation exposing (nextSlide, prevSlide, goToSlide)

{-| Navigation functions for slide presentation

@docs nextSlide, prevSlide, goToSlide

-}


{-| Navigate to the next slide. Clamps to the last slide if already at the end.
-}
nextSlide : Int -> Int -> Int
nextSlide currentIndex totalSlides =
    let
        maxIndex =
            totalSlides - 1
    in
    min maxIndex (currentIndex + 1)


{-| Navigate to the previous slide. Clamps to the first slide (index 0) if already at the beginning.
-}
prevSlide : Int -> Int
prevSlide currentIndex =
    max 0 (currentIndex - 1)


{-| Navigate to a specific slide by index. No bounds checking is performed.
-}
goToSlide : Int -> Int
goToSlide index =
    index
