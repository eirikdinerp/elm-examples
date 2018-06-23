module Wishlist.Encoder exposing (..)

import Json.Encode as Encode exposing (Value)
import Date.Extra.Format

import Wishlist exposing (Wishlist)

encodeWishlist : Wishlist -> Value
encodeWishlist { uuid, title, description, date } =
  Encode.object <|
    List.append
      [ ("title", Encode.string title)
      , ("description", Encode.string description)
      , ("date", Encode.string <| Date.Extra.Format.isoString date)
      ] <|
      if uuid == "" then
        []
      else
        [ ("uuid", Encode.string uuid) ]