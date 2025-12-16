module I18n exposing
    ( Language(..)
    , Translations
    , decodeLanguage
    , defaultLanguage
    , encodeLanguage
    , translations
    )

import Json.Decode as Decode
import Json.Encode as Encode



-- TYPES


type Language
    = English
    | Finnish


type alias Translations =
    { -- Sidebar
      presentationTitlePlaceholder : String
    , addSlide : String
    , present : String
    , importPPTX : String
    , exportPPTX : String

    -- Editor
    , removeImage : String
    , uploadImage : String

    -- Slide actions (ARIA labels)
    , moveSlideUp : String
    , moveSlideDown : String
    , duplicateSlide : String
    , deleteSlide : String
    , addNewSlide : String

    -- Help dialog
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

    -- Announcements
    , slideAnnouncement : Int -> Int -> String
    , enteringPresentMode : String
    , exitingPresentMode : String
    , slideAdded : String
    , slideDeleted : String
    , slideDuplicated : String
    , slideMovedUp : String
    , slideMovedDown : String

    -- Accessibility
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

    -- Language selector
    , language : String
    , selectLanguage : String
    }



-- DEFAULT


defaultLanguage : Language
defaultLanguage =
    English



-- TRANSLATIONS


translations : Language -> Translations
translations lang =
    case lang of
        English ->
            englishTranslations

        Finnish ->
            finnishTranslations


englishTranslations : Translations
englishTranslations =
    { presentationTitlePlaceholder = "Presentation Title"
    , addSlide = "+"
    , present = "Present"
    , importPPTX = "Import PPTX"
    , exportPPTX = "Export PPTX"
    , removeImage = "Remove Image"
    , uploadImage = "📁 Upload Image"
    , moveSlideUp = "Move slide up"
    , moveSlideDown = "Move slide down"
    , duplicateSlide = "Duplicate slide"
    , deleteSlide = "Delete slide"
    , addNewSlide = "Add new slide"
    , keyboardShortcuts = "Keyboard Shortcuts"
    , close = "Close"
    , navigation = "Navigation"
    , nextSlide = "Next slide"
    , previousSlide = "Previous slide"
    , firstSlide = "First slide"
    , lastSlide = "Last slide"
    , enterPresentation = "Enter presentation mode"
    , exitPresentation = "Exit presentation mode"
    , slideManagement = "Slide Management"
    , reorderSlideUp = "Move current slide up"
    , reorderSlideDown = "Move current slide down"
    , fileOperations = "File Operations"
    , importFile = "Import PPTX file"
    , uploadImageFile = "Upload image to current slide"
    , exportFile = "Export to PPTX"
    , other = "Other"
    , showHelp = "Show this help dialog"
    , slideAnnouncement = \current total -> "Slide " ++ String.fromInt current ++ " of " ++ String.fromInt total
    , enteringPresentMode = "Entering presentation mode"
    , exitingPresentMode = "Exiting presentation mode"
    , slideAdded = "Slide added"
    , slideDeleted = "Slide deleted"
    , slideDuplicated = "Slide duplicated"
    , slideMovedUp = "Slide moved up"
    , slideMovedDown = "Slide moved down"
    , slideNavigation = "Slide navigation"
    , slideList = "Slide list"
    , slideEditor = "Slide editor"
    , slideActions = "Slide actions"
    , imageControls = "Image controls"
    , skipToContent = "Skip to main content"
    , presentationTitle = "Presentation title"
    , enterPresentationMode = "Enter presentation mode"
    , importPPTXFile = "Import PowerPoint PPTX file"
    , exportToPPTX = "Export to PowerPoint PPTX"
    , uploadImageLabel = "Upload image file"
    , removeImageLabel = "Remove current image from slide"
    , language = "Language"
    , selectLanguage = "Select language"
    }


finnishTranslations : Translations
finnishTranslations =
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



-- ENCODING / DECODING


encodeLanguage : Language -> Encode.Value
encodeLanguage lang =
    case lang of
        English ->
            Encode.string "en"

        Finnish ->
            Encode.string "fi"


decodeLanguage : Decode.Decoder Language
decodeLanguage =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "en" ->
                        Decode.succeed English

                    "fi" ->
                        Decode.succeed Finnish

                    _ ->
                        Decode.succeed defaultLanguage
            )
