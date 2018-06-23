port module Firebase exposing (..)

{-| Handle everything related with Firebase. Firebase works with the JS
SDK, which should be included in the generated `bundle.js`. Everything
flow through ports and are processed in JS. The elm side does not handle
anything side-effect related, like database, or authentication yet. Firebase
effect manager should be used in the future, in order to remove entirely JS
from the project.
Port names should respect a simple convention: commands (orders to Firebase)
should be imperative, where subscriptions (responses from Firebase) should
be either past indicating what happened or what's happening now to respect
actual elm conventions. -}

import Json.Decode exposing (Value)

{-| Accept a username and a title. The wishlist takes form of
`  { uuid : String, title : String, description : String, createdBy: String, status: String, date : Date }`. 
It creates a wishlist on the database.
Should be used with `Wishlist.Encoder.encodeWishlist`. -}
port createWishlist : (String, Value) -> Cmd msg

{-| Give answer whether post has been accepted (pushed in the database) or
not. Will be used to process errors in future. -}
port createdPost : (Bool -> msg) -> Sub msg

{-| Accept a username and an article. The article takes form of
`{ title, uuid, content, date, tags }`. It updates a post on the database.
Should be used with `Article.Encoder.encodeArticle`. -}
port updatePost : (String, Value) -> Cmd msg

{-| Give answer whether post has been accepted (updated in the database) or
not. Will be used to process errors in future. -}
port updatedPost : (Bool -> msg) -> Sub msg


{-| Request all wishlists of a user (provided username). Wishlists are fetched in Firebase
once. Response comes in `requestedWishlists` port. It is impossible to select only
some wishlists to fetch at the moment. -}
port requestWishlists : String -> Cmd msg

{-| Receive all fetched wishlists, requested by `requestWishlists`. They come in an
assoc JSON. They should be processed with `Wishlist.Decoder.decodeWishlists`. -}
port requestedWishlists : (Value -> msg) -> Sub msg


{-| Accept username and password, and sign in or log in the user to the
site. All changes on the user are sent in `authChanges`. -}
port signInUser : (String, String) -> Cmd msg

{-| Accept a username and logout the user. All changes on the user are
sent in `authChanges`. -}
port logoutUser : String -> Cmd msg


{-| Send all authentication changes. Should be processed with
`User.Decoder.decodeUser`. If a user is connected, forward a user to elm,
otherwise it forward an error JSON, i.e. `{disconnected: true}`. -}
port authChanges : (Value -> msg) -> Sub msg