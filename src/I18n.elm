module I18n exposing
    ( Language(..)
    , Translations
    , decodeLanguage
    , defaultLanguage
    , encodeLanguage
    , translations
    )

{-| Internationalization (i18n) module for multi-language support.

This module provides a type-safe translation system using union types and record types
to ensure all translations are present at compile time.


# Architecture

The i18n system uses three key components:

1.  **Language Type**: A union type listing all supported languages
2.  **Translations Record**: A record type defining all translatable strings
3.  **Translation Functions**: Functions that return translations for each language


# Usage Pattern

In your view code, get translations for the current language:

    let
        t =
            I18n.translations model.language
    in
    button [] [ text t.addSlide ]


# Adding a New Language

To add support for a new language:

1.  Add a variant to the `Language` type (e.g., `| Swedish`)
2.  Create a translation function (e.g., `swedish : Translations`)
3.  Update the `translations` function to handle the new variant
4.  Update `encodeLanguage` and `decodeLanguage` for storage
5.  Update language selector UI in View.Edit module


# Translation Key Naming Conventions

  - Use camelCase for all keys
  - Group related translations by UI section (sidebar, editor, help)
  - Suffix ARIA labels with explicit context (e.g., `moveSlideUp` for action, `moveSlideUpLabel` for aria-label)
  - Keep keys descriptive and indicate their UI context
  - Function fields like `slideAnnouncement` take parameters and return formatted strings

-}

import Json.Decode as Decode
import Json.Encode as Encode



-- TYPES


{-| Supported languages.

Add new variants here when adding support for additional languages.
Each variant represents one language/locale supported by the application.

-}
type Language
    = English
    | Finnish


{-| Complete set of translatable strings for the application.

This record type ensures that every translation is present for every language at compile time.
If you add a new string that needs translation, add it here first, then the compiler
will guide you to add it to all language translation functions.

Fields are organized by UI section:

  - Sidebar: Navigation, file operations
  - Editor: Content editing controls
  - Slide actions: ARIA labels for accessibility
  - Help dialog: Keyboard shortcuts documentation
  - Announcements: Screen reader live region announcements
  - Accessibility: Additional ARIA labels and navigation
  - Language selector: Language switching UI

-}
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


{-| The default language used on first launch before user selects a preference.
-}
defaultLanguage : Language
defaultLanguage =
    English



-- TRANSLATIONS


{-| Get the complete set of translations for a given language.

This is the main entry point for accessing translations in your view code.

Example:

    let
        t =
            I18n.translations model.language
    in
    div []
        [ button [ onClick AddSlide ] [ text t.addSlide ]
        , button [ onClick EnterPresentMode ] [ text t.present ]
        ]

-}
translations : Language -> Translations
translations lang =
    case lang of
        English ->
            englishTranslations

        Finnish ->
            finnishTranslations


{-| English translations (default language).

This serves as the baseline for all other translations. All strings should
be clear, concise, and follow standard English UI conventions.

-}
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


{-| Finnish translations (Suomi).

Finnish translations follow informal tone ("sinä" form) for a friendly user experience.
Translations are concise to fit UI constraints while maintaining clarity.

Key considerations:

  - Informal tone (sinä-muoto) for accessibility
  - Concise wording for button labels
  - Natural Finnish phrasing, not literal translations
  - Technical terms (PPTX, PowerPoint) kept in English

-}
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


{-| Encode a language to JSON for local storage.

Languages are stored as ISO 639-1 two-letter language codes:

  - English → "en"
  - Finnish → "fi"

-}
encodeLanguage : Language -> Encode.Value
encodeLanguage lang =
    case lang of
        English ->
            Encode.string "en"

        Finnish ->
            Encode.string "fi"


{-| Decode a language from JSON stored in local storage.

Falls back to the default language if the stored value is unrecognized.
This ensures the app always has a valid language even if storage is corrupted
or contains a language code we don't support.

-}
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
