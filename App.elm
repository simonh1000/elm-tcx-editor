module App (AppState, Model, init, update, view, toString) where

import Html exposing (..)
import Html.Attributes exposing (..)

import Effects exposing (Effects)

import Upload exposing (Action(..))
import Editor
import TcxDecoder exposing (Model)

-- MODEL
type AppState =
      Uploading
    | Editing
    | ErrorState

toString : AppState -> String
toString a =
    case a of
        Uploading -> "Uploading"
        Editing -> "Editing"
        ErrorState -> "Error"

type alias Model =
    { state : AppState
    , data : Upload.Model
    }

init : Model
init =
    { state = Uploading
    , data = Upload.init
    }

-- UPDATE

type Action =
      Uploader Upload.Action
    | Editor Editor.Action

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Uploader Ready -> ({ model | state <- Editing }, Effects.none)
        Uploader data ->
            let
                tmp = Upload.update data model.data
                newModel =
                    { model | data <- fst tmp
                    }
            in (newModel, Effects.map Uploader (snd tmp))
        Editor editorAction -> (model, Effects.none)
        otherwise ->
            let newModel =
                { model | state <- ErrorState }
            in (newModel, Effects.none)

-- VIEW

-- Signal.forwardTo (Address b -> a -> b)
view : Signal.Address Action -> Model -> Html
view address model =
    let
        viewTemplate = case model.state of
            Uploading ->
                Upload.view (Signal.forwardTo address Uploader) model.data
            Editing ->
                Editor.view (Signal.forwardTo address Editor) model.data
            ErrorState ->
                text <| "Error"
    in
        div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-xs-12" ]
                    [ h1 [] [ text "Garmin GPS .tcx editor" ] ]
                ]
            , viewTemplate
            ]
