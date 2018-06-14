module Validation exposing (..)

type alias Validator a b = a -> Result String b

isNotEmpty : Validator String String
isNotEmpty value =
  if value == ""
    then Err "This field is Required"
    else Ok value

isEmail : Validator String String
isEmail value =
  if String.contains "@" value
    then Ok value
    else Err "Please enter a valid email adress"

isInt : Validator String Int 
isInt = String.toInt