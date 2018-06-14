import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)

import Http
import Json.Encode as Encode
import Json.Decode as Json

import Validation exposing (..)

type alias Model =
  { email : Field String
  , message : Field String
  , age : OptionalField Int
  , status : SubmissionStatus
  }

type SubmissionStatus
    = NotSubmitted
    | InProcess
    | Succeded
    | Failed

initialModel : Model
initialModel =
  { email = NotValidated ""
  , message = NotValidated ""
  , age = NotValidated ""
  , status = NotSubmitted
  }

type Msg
  = InputEmail String
  | InputMessage String
  | Submit
  | InputAge String
  | SubmitResponse (Result Http.Error () )

main : Program Never Model Msg
main =
  program
    { init = (initialModel, Cmd.none)
    , update = update
    , subscriptions = \model -> Sub.none
    , view = view
    }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        InputEmail e ->
            ({model | email = NotValidated e}, Cmd.none)
        InputMessage m ->
            ({model | message = NotValidated m}, Cmd.none)
        InputAge a ->
            ({model | age = NotValidated a}, Cmd.none)
        Submit ->
            model |> validateModel |> submitIfValid
        SubmitResponse (Ok ()) ->
            ({model | status = Succeded
            , email = NotValidated ""
            , message = NotValidated ""}, Cmd.none)
        SubmitResponse (Err _) ->
            ({model | status = Failed}, Cmd.none)

validateModel : Model -> Model 
validateModel model = 
  let
    emailValidation = 
      isNotEmpty "An email is required"
      >=> isEmail "Please ensure this is a valid email"

    email = model.email |> validate emailValidation

    message = model.message
      |> validate (isNotEmpty "A mesage is required")

    age = model.age
      |> validate (optional (isNatural "I'm expecting a positive number"))


  in
    {model | email = email
    , message = message
    , age = age
    }

submitIfValid : Model -> (Model, Cmd Msg)
submitIfValid model =
  let
    submissionResult = 
      Valid submit
        |: model.email
        |: model.message 
        |: model.age
    
  in case submissionResult of
    Valid cmd ->
      ({model | status = InProcess}, cmd)
    _ ->
      (model, Cmd.none)
            
submit : String -> String -> Maybe Int ->  Cmd Msg
submit email message age =
    let
        url = "http://localhost:3000/api/contact"

        json = Encode.object
            [ ("email", Encode.string email)
            , ("message", Encode.string message)
            , ("age", age |> Maybe.map Encode.int
                          |> Maybe.withDefault Encode.null )
            ]

        decoder = Json.string |> Json.map (always () )


        request = Http.post url (Http.jsonBody json) decoder

    in request |> Http.send SubmitResponse

view : Model -> Html Msg
view model =
  Html.form 
    [ onSubmit Submit
    , novalidate True
    ]
    [ header model
    , body model
    , footer model
    , div [] [ model |> toString |> text ]
    ]

header  model = div []
  [ h1 [] [ text "Contact us" ] 
  , renderStatus model.status]

renderStatus status = 
    case status of
        NotSubmitted ->
            div [] [] 
        InProcess ->
            div [] [text "Your request is being sent"]
        Succeded ->
            div [] [text "Your request has been received"]
        Failed ->
            div [class "alert alert-danger"] 
            [ text "Ops! There was an error, please try again"]

errorLabel : Field a -> Html Msg
errorLabel field = label 
      [ class "label lable-error" ]
      [ field 
        |> extractError 
        |> Maybe.withDefault "" 
        |> text
      ]

body model = div []
  [ div []
    [ input
      [ placeholder "your email *"
      , type_ "email"
      , onInput InputEmail
      , value (model.email |> displayValue identity)
      , required True
      ] []
      , errorLabel model.email
    ]
  , div []
    [ textarea
      [ placeholder "your message *"
      , rows 7
      , onInput InputMessage
      , value (model.message |> displayValue identity)
      , required True
      ] []
      , errorLabel model.message 
      ]
    
  , div []
    [ input
      [ placeholder "your age"
      , onInput InputAge
      , value (model.age 
      |> displayValue (Maybe.map toString >> Maybe.withDefault ""))
      ] []
      , errorLabel model.age 
      ]
  ]

footer model = div []
    [ button
        [ type_ "submit"
        , disabled (model.status == InProcess) ] 
        [ text "Submit" ]
        , button 
        [ type_ "button" ]
        [ text "Cancel" ] 
    ]
