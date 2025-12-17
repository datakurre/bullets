module I18n.En exposing (translations)

{-| English translations for the bullets presentation tool.


# Translations

@docs translations

-}


{-| English translations (default language).

This serves as the baseline for all other translations. All strings should
be clear, concise, and follow standard English UI conventions.

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
