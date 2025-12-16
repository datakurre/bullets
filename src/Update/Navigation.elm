module Update.Navigation exposing (goToSlide, nextSlide, prevSlide)

{-| Update handlers for navigation-related messages.

This module handles slide navigation in both edit and presentation modes.

-}

import I18n
import Navigation
import Types exposing (Model, Msg)


{-| Move to the next slide. Stays at last slide if already at end.
-}
nextSlide : Model -> ( Model, Cmd Msg )
nextSlide model =
    let
        totalSlides =
            List.length model.presentation.slides

        newIndex =
            Navigation.nextSlide model.currentSlideIndex totalSlides

        t =
            I18n.translations model.language
    in
    ( { model
        | currentSlideIndex = newIndex
        , announcement = t.slideAnnouncement (newIndex + 1) totalSlides
      }
    , Cmd.none
    )


{-| Move to the previous slide. Stays at first slide if already at start.
-}
prevSlide : Model -> ( Model, Cmd Msg )
prevSlide model =
    let
        totalSlides =
            List.length model.presentation.slides

        newIndex =
            Navigation.prevSlide model.currentSlideIndex

        t =
            I18n.translations model.language
    in
    ( { model
        | currentSlideIndex = newIndex
        , announcement = t.slideAnnouncement (newIndex + 1) totalSlides
      }
    , Cmd.none
    )


{-| Navigate to a specific slide by index. Clamps to valid range.
-}
goToSlide : Int -> Model -> ( Model, Cmd Msg )
goToSlide index model =
    let
        totalSlides =
            List.length model.presentation.slides

        t =
            I18n.translations model.language
    in
    ( { model
        | currentSlideIndex = Navigation.goToSlide index
        , announcement = t.slideAnnouncement (index + 1) totalSlides
      }
    , Cmd.none
    )
