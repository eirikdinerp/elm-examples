module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Json.Decode as Decode
import Json.Encode as Encode

import Wishlist exposing (..)
import Wishlist.Decoder
import Wishlist.Encoder

-- component import example
import Components.Hello exposing ( hello )

import Firebase

-- APP
main : Program Never Model Msg
main =
  Html.program { init= init, view = view, update = update, subscriptions = subscriptions }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ 
      -- Window.resizes Resizes
     firebaseSubscriptions model
    -- , fromLocalStorage RestoreArticles
    ]

firebaseSubscriptions : Model -> Sub Msg
firebaseSubscriptions model =
    Sub.batch
    [ 
      Sub.none
      --Firebase.requestedWishlists GetWishlists
    ]

init : ( Model, Cmd Msg )
init =
    ( emptyModel, Cmd.none )

-- MODEL
type alias Model = { counter : Int, wishlists : List Wishlist }

emptyModel : Model
emptyModel = {
  counter = 0,
  wishlists = []
 }


-- UPDATE
type Msg = NoOp | Increment |  RequestWishlists --| GetWishlists Decode.Value

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    -- GetWishlists -> model ! [Cmd.none]
    NoOp -> (model, Cmd.none)
    Increment -> ( { model | counter = model.counter +1 }, Cmd.none)
    RequestWishlists ->
      model ! [Firebase.requestWishlists ""]
    -- GetWishlists wishlists ->
      -- wishlists 
      -- |> Decode.decodeValue Wishlist.Decoder.decodeWishlists
      -- |> Result.withDefault []
      -- |> ( { model | wishlists = wishlists},  Cmd.none)
      -- |> ( { model | wishlist = Just wishlist }
      -- , Cmd.none
      -- )



-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [ class "container", style [("margin-top", "30px"), ( "text-align", "center" )] ][    -- inline CSS (literal)
    div [ class "row" ][
      div [ class "col-xs-12" ][
        div [ class "jumbotron" ][
          img [ src "static/img/elm.jpg", style styles.img ] []                             -- inline CSS (via var)
          , hello model.counter                                                                     -- ext 'hello' component (takes 'model' as arg)
          , p [] [ text ( "Elm Webpack Starter" ) ]
          , button [ class "btn btn-primary btn-lg", onClick RequestWishlists ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "FTW!" ]
          ]
        ]
      ]
    ]
  ]


-- CSS STYLES
styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }
