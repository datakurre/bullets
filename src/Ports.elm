port module Ports exposing (exportToPPTX, imagePasted, importPPTXRequested, loadFromLocalStorage, localStorageLoaded, pptxImported, saveToLocalStorage, setupImagePaste)

import Json.Encode as Encode


-- Outgoing port to tell JavaScript to setup image paste listener


port setupImagePaste : () -> Cmd msg



-- Incoming port to receive pasted image data URI


port imagePasted : (String -> msg) -> Sub msg



-- Outgoing port to save presentation to local storage


port saveToLocalStorage : String -> Cmd msg



-- Outgoing port to request loading from local storage


port loadFromLocalStorage : () -> Cmd msg



-- Incoming port to receive loaded presentation from local storage


port localStorageLoaded : (String -> msg) -> Sub msg



-- Outgoing port to export presentation to PowerPoint PPTX format


port exportToPPTX : Encode.Value -> Cmd msg



-- Outgoing port to request PPTX import (triggers file picker)


port importPPTXRequested : () -> Cmd msg



-- Incoming port to receive imported presentation data from PPTX


port pptxImported : (String -> msg) -> Sub msg
