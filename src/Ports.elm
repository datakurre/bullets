port module Ports exposing (imagePasted, loadFromLocalStorage, localStorageLoaded, saveToLocalStorage, setupImagePaste)

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
