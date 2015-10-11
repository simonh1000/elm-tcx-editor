module App (init, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)

import Effects exposing (Effects)

import Upload exposing (Action(FileData))
import Processor
import TcxDecoder exposing (Model)

-- MODEL
type AppState =
      Waiting
    | Processing
    | Editing
    | ErrorState

type alias Model =
    { state : AppState
    , data : Upload.Model
    -- , lapData : Processor.Model
    , loadMap : Bool
    }

init : Model
init =
    { state = Waiting
    , data = Upload.init
    -- , lapData = Processor.init
    , loadMap = False
    }

-- UPDATE

type Action =
      Uploader Upload.Action
    -- | Editor Editor.Action

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Uploader data ->
            let
                tmp = Upload.update data model.data
                newModel =
                    { model | state <- Processing
                            , data <- fst tmp
                    }
            in (newModel, Effects.map Uploader (snd tmp))
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
            Waiting ->
                Upload.view (Signal.forwardTo address Uploader) model.data
            Processing ->
                text <| "Processing: " ++ model.data.rawdata
                -- Processor.view (Signal.forwardTo address Processed) model.lapData
            ErrorState ->
                text <| "Error"
    in
        div []
            [ h1 [] [ text "TCX Editor" ]
            , viewTemplate
            ]
