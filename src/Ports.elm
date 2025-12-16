port module Ports exposing (imagePasted, setupImagePaste)

-- Outgoing port to tell JavaScript to setup image paste listener


port setupImagePaste : () -> Cmd msg



-- Incoming port to receive pasted image data URI


port imagePasted : (String -> msg) -> Sub msg
