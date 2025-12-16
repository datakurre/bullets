module Types exposing
    ( Mode(..)
    , Model
    , Msg(..)
    , Presentation
    , Slide
    , SlideLayout(..)
    , initialModel
    )

import File exposing (File)



-- TYPES


type Mode
    = Edit
    | Present


type SlideLayout
    = JustMarkdown
    | MarkdownWithImage


type alias Slide =
    { content : String
    , layout : SlideLayout
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
    }


type Msg
    = NextSlide
    | PrevSlide
    | GoToSlide Int
    | EnterPresentMode
    | ExitPresentMode
    | AddSlide
    | DeleteSlide Int
    | DuplicateSlide Int
    | MoveSlideUp Int
    | MoveSlideDown Int
    | UpdateContent String
    | ChangeLayout SlideLayout
    | ImagePasted String
    | RemoveImage
    | DownloadJSON
    | LoadJSONRequested
    | FileSelected File
    | FileLoaded String
    | ImageUploadRequested
    | ImageFileSelected File
    | ImageFileLoaded String
    | KeyPressed String
    | LocalStorageLoaded String



-- INITIAL VALUES


initialSlide : Slide
initialSlide =
    { content = "# Welcome to Bullets\n\nA minimal presentation tool"
    , layout = JustMarkdown
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
    }
