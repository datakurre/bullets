module I18n.Fi exposing (translations)

{-| Finnish translations (Suomi) for the bullets presentation tool.


# Translations

@docs translations

-}


{-| Finnish translations (Suomi).

Finnish translations follow informal tone ("sinä" form) for a friendly user experience.
Translations are concise to fit UI constraints while maintaining clarity.

Key considerations:

  - Informal tone (sinä-muoto) for accessibility
  - Concise wording for button labels
  - Natural Finnish phrasing, not literal translations
  - Technical terms (PPTX, PowerPoint) kept in English

-}
translations :
    { presentationTitlePlaceholder : String
    , addSlide : String
    , present : String
    , importPPTX : String
    , exportPPTX : String
    , removeImage : String
    , uploadImage : String
    , moveSlideUp : String
    , moveSlideDown : String
    , duplicateSlide : String
    , deleteSlide : String
    , addNewSlide : String
    , keyboardShortcuts : String
    , close : String
    , navigation : String
    , nextSlide : String
    , previousSlide : String
    , firstSlide : String
    , lastSlide : String
    , enterPresentation : String
    , exitPresentation : String
    , slideManagement : String
    , reorderSlideUp : String
    , reorderSlideDown : String
    , fileOperations : String
    , importFile : String
    , uploadImageFile : String
    , exportFile : String
    , other : String
    , showHelp : String
    , slideAnnouncement : Int -> Int -> String
    , enteringPresentMode : String
    , exitingPresentMode : String
    , slideAdded : String
    , slideDeleted : String
    , slideDuplicated : String
    , slideMovedUp : String
    , slideMovedDown : String
    , slideNavigation : String
    , slideList : String
    , slideEditor : String
    , slideActions : String
    , imageControls : String
    , skipToContent : String
    , presentationTitle : String
    , enterPresentationMode : String
    , importPPTXFile : String
    , exportToPPTX : String
    , uploadImageLabel : String
    , removeImageLabel : String
    , language : String
    , selectLanguage : String
    }
translations =
    { presentationTitlePlaceholder = "Esityksen otsikko"
    , addSlide = "+"
    , present = "Esitä"
    , importPPTX = "Tuo PPTX"
    , exportPPTX = "Vie PPTX"
    , removeImage = "Poista kuva"
    , uploadImage = "📁 Lataa kuva"
    , moveSlideUp = "Siirrä dia ylös"
    , moveSlideDown = "Siirrä dia alas"
    , duplicateSlide = "Kopioi dia"
    , deleteSlide = "Poista dia"
    , addNewSlide = "Lisää uusi dia"
    , keyboardShortcuts = "Pikanäppäimet"
    , close = "Sulje"
    , navigation = "Navigointi"
    , nextSlide = "Seuraava dia"
    , previousSlide = "Edellinen dia"
    , firstSlide = "Ensimmäinen dia"
    , lastSlide = "Viimeinen dia"
    , enterPresentation = "Aloita esitys"
    , exitPresentation = "Lopeta esitys"
    , slideManagement = "Diojen hallinta"
    , reorderSlideUp = "Siirrä nykyinen dia ylös"
    , reorderSlideDown = "Siirrä nykyinen dia alas"
    , fileOperations = "Tiedosto-operaatiot"
    , importFile = "Tuo PPTX-tiedosto"
    , uploadImageFile = "Lataa kuva nykyiselle dialle"
    , exportFile = "Vie PPTX-muotoon"
    , other = "Muut"
    , showHelp = "Näytä tämä ohjedialog"
    , slideAnnouncement = \current total -> "Dia " ++ String.fromInt current ++ " / " ++ String.fromInt total
    , enteringPresentMode = "Siirrytään esitystilaan"
    , exitingPresentMode = "Poistutaan esitystilasta"
    , slideAdded = "Dia lisätty"
    , slideDeleted = "Dia poistettu"
    , slideDuplicated = "Dia kopioitu"
    , slideMovedUp = "Dia siirretty ylös"
    , slideMovedDown = "Dia siirretty alas"
    , slideNavigation = "Diojen navigointi"
    , slideList = "Dialuettelo"
    , slideEditor = "Dian muokkain"
    , slideActions = "Dian toiminnot"
    , imageControls = "Kuvan hallinta"
    , skipToContent = "Siirry sisältöön"
    , presentationTitle = "Esityksen otsikko"
    , enterPresentationMode = "Siirry esitystilaan"
    , importPPTXFile = "Tuo PowerPoint PPTX-tiedosto"
    , exportToPPTX = "Vie PowerPoint PPTX-muotoon"
    , uploadImageLabel = "Lataa kuvatiedosto"
    , removeImageLabel = "Poista kuva dialta"
    , language = "Kieli"
    , selectLanguage = "Valitse kieli"
    }
