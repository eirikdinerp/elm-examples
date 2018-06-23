module Wishlist.Decoder exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra
import Date exposing (Date)

import Wishlist exposing (Wishlist)

decodeWishlists : Decoder (List (String, Wishlist))
decodeWishlists =
  Decode.keyValuePairs decodeWishlist

decodeWishlist : Decoder Wishlist
decodeWishlist =
  Decode.map5 wishlist
    (Decode.field "title" Decode.string)
    (Decode.field "description" Decode.string)
    (Decode.field "createdBy" Decode.string)
    (Decode.field "status" Decode.string)
    (Decode.field "date" Json.Decode.Extra.date)

wishlist : String -> String -> String -> String -> Date -> Wishlist
wishlist title description createdBy status date =
  { uuid = ""
  , title = title
  , description = description
  , createdBy = createdBy
  , status = status
  , date = date
  
  }
