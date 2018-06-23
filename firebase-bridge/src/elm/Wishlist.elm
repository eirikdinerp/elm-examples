module Wishlist exposing (..)
import Date exposing (Date)

type alias Wishlist =
  { uuid : String
  , title : String
  , description : String
  , createdBy: String
  , status: String
  , date : Date
  }