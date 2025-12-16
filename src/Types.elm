module Types exposing
    ( Mode(..)
    , Model
    , Msg(..)
    , Presentation
    , Slide
    , initialModel
    )

import File exposing (File)
import I18n exposing (Language)



-- TYPES


type Mode
    = Edit
    | Present


type alias Slide =
    { content : String
    , image : Maybe String
    }


type alias Presentation =
    { slides : List Slide
    , title : String
    , author : String
    , created : String
    }


type alias Model =
    { mode : Mode
    , currentSlideIndex : Int
    , presentation : Presentation
    , editingContent : String
    , draggedSlideIndex : Maybe Int
    , dropTargetIndex : Maybe Int
    , isTextareaFocused : Bool
    , showHelpDialog : Bool
    , announcement : String
    , language : Language
    }


type Msg
    = NextSlide
    | PrevSlide
    | GoToSlide Int
    | EnterPresentMode
    | ExitPresentMode
    | AddSlide
    | AddSlideAfter Int
    | DeleteSlide Int
    | DuplicateSlide Int
    | MoveSlideUp Int
    | MoveSlideDown Int
    | UpdateContent String
    | UpdateTitle String
    | ImagePasted String
    | RemoveImage
    | ImageUploadRequested
    | ImageFileSelected File
    | ImageFileLoaded String
    | KeyPressed String Bool Bool
      -- KeyPressed key ctrlKey shiftKey
    | LocalStorageLoaded String
    | DragStart Int
    | DragOver Int
    | DragEnd
    | Drop Int
    | TextareaFocused
    | TextareaBlurred
    | ExportToPPTX
    | ImportPPTXRequested
    | PPTXImported String
    | ToggleHelpDialog
    | ChangeLanguage Language
    | LanguageLoaded String



-- INITIAL VALUES


initialSlide : Slide
initialSlide =
    { content = "# Welcome to Bullets\n\nA minimal presentation tool"
    , image = Nothing
    }


initialPresentation : Presentation
initialPresentation =
    { slides = [ initialSlide ]
    , title = "Untitled Presentation"
    , author = ""
    , created = ""
    }


initialModel : Model
initialModel =
    { mode = Edit
    , currentSlideIndex = 0
    , presentation = initialPresentation
    , editingContent = initialSlide.content
    , draggedSlideIndex = Nothing
    , dropTargetIndex = Nothing
    , isTextareaFocused = False
    , showHelpDialog = False
    , announcement = ""
    , language = I18n.defaultLanguage
    }
