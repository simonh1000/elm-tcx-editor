module Upload (Model, Action(..), init, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Http
import Effects exposing (Effects)
import Task exposing (Task)

import TcxDecoder exposing (tcxDecoder)
import FileReader exposing (getTextFile)

-- MODEL

-- type alias Model = String
type alias Model =
    { rawdata : String
    , jsonData: TcxDecoder.Model
    }

init : Model
-- init = ""
init =
    { rawdata = ""
    , jsonData = []
    }

-- UPDATE

type Action =
        Upload
      | FileData String
      | JsonData (Result Http.Error TcxDecoder.Model)

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Upload -> ( model, loadData )
        FileData str -> ( {model | rawdata <- str}, sendToRemote str )
        JsonData res -> (model, Effects.none)

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ p [] [ text "Upload file" ]
        , input [ type' "file", id "input" ] []
        , button [ onClick address Upload ] [ text "Upload" ]
        ]

-- TASKS

-- Read File
-- getTextFile : String -> Task FileReader.Error String
loadData : Effects Action
loadData =
    getTextFile "input" `Task.onError` (\err -> Task.succeed (errorMapper err))
        |> Task.map FileData
        |> Effects.task

errorMapper : FileReader.Error -> String
errorMapper err =
    case err of
        FileReader.ReadFail -> "File reading error"
        FileReader.NoFileSpecified -> "No file specified"


-- Converting to Json

-- processor : String -> Model
-- processor rawData = []

-- post : Decoder value -> String -> Body -> Task Error value
sendToRemote : String -> Effects Action
sendToRemote rawData =
    -- Http.post tcxDecoder "http://localhost:5000/tcx/tojson" (Http.string rawData)
    Http.get tcxDecoder "http://localhost:5000/tcx/test"
        |> Task.toResult
        |> Task.map JsonData
        |> Effects.task
