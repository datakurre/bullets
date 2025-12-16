module Update exposing (update)

{-| Main update coordinator.

This module routes update messages to the appropriate Update.\* sub-modules.
It provides a single entry point for all state updates in the application.

-}

import Types exposing (Model, Msg(..))
import Update.Content
import Update.FileIO
import Update.Image
import Update.Keyboard
import Update.Mode
import Update.Navigation
import Update.Slide
import Update.Storage
import Update.UI


{-| Main update function that coordinates all state changes.

Routes messages to appropriate Update.\* modules based on message type.

-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- NAVIGATION
        NextSlide ->
            Update.Navigation.nextSlide model

        PrevSlide ->
            Update.Navigation.prevSlide model

        GoToSlide index ->
            Update.Navigation.goToSlide index model

        -- MODE SWITCHING
        EnterPresentMode ->
            Update.Mode.enterPresentMode model

        ExitPresentMode ->
            Update.Mode.exitPresentMode model

        -- SLIDE MANAGEMENT
        AddSlide ->
            Update.Slide.addSlide model

        AddSlideAfter index ->
            Update.Slide.addSlideAfter index model

        DeleteSlide index ->
            Update.Slide.deleteSlide index model

        DuplicateSlide index ->
            Update.Slide.duplicateSlide index model

        MoveSlideUp index ->
            Update.Slide.moveSlideUp index model

        MoveSlideDown index ->
            Update.Slide.moveSlideDown index model

        -- CONTENT EDITING
        UpdateContent content ->
            Update.Content.updateContent content model

        UpdateTitle title ->
            Update.Content.updateTitle title model

        -- IMAGE HANDLING
        ImagePasted dataUri ->
            Update.Image.imagePasted dataUri model

        RemoveImage ->
            Update.Image.removeImage model

        ImageUploadRequested ->
            Update.Image.imageUploadRequested model

        ImageFileSelected file ->
            Update.Image.imageFileSelected file model

        ImageFileLoaded dataUri ->
            Update.Image.imageFileLoaded dataUri model

        -- KEYBOARD HANDLING
        KeyPressed key ctrlKey shiftKey ->
            Update.Keyboard.keyPressed key ctrlKey shiftKey model

        -- DRAG AND DROP
        DragStart index ->
            Update.Slide.dragStart index model

        DragOver targetIndex ->
            Update.Slide.dragOver targetIndex model

        DragEnd ->
            Update.Slide.dragEnd model

        Drop targetIndex ->
            Update.Slide.drop targetIndex model

        -- STORAGE
        LocalStorageLoaded content ->
            Update.Storage.localStorageLoaded content model

        -- TEXTAREA FOCUS STATE
        TextareaFocused ->
            Update.UI.textareaFocused model

        TextareaBlurred ->
            Update.UI.textareaBlurred model

        -- FILE OPERATIONS
        ExportToPPTX ->
            Update.FileIO.exportToPPTX model

        ImportPPTXRequested ->
            Update.FileIO.importPPTXRequested model

        PPTXImported jsonString ->
            Update.FileIO.pptxImported jsonString model

        -- UI STATE
        ToggleHelpDialog ->
            Update.UI.toggleHelpDialog model

        ChangeLanguage language ->
            Update.UI.changeLanguage language model

        LanguageLoaded jsonString ->
            Update.UI.languageLoaded jsonString model
