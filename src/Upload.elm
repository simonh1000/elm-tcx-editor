module Upload (Model, Action(..), init, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Http
import Effects exposing (Effects)
import Task exposing (Task)

import English
import TcxDecoder exposing (tcxDecoder)
import FileReader exposing (getTextFile)

-- MODEL

type alias Model =
    { raw : String
    , json: TcxDecoder.Model
    , errorMessage : String
    }

init : Model
init =
    { raw = ""
    , json = []
    , errorMessage = ""
    }

-- UPDATE

type Action =
        Upload
      | Demo
      | FileData String
      | JsonData (Result Http.Error TcxDecoder.Model)
      | Ready

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Upload -> ( model, loadData )
        Demo   -> ( model, getDemoData )
        FileData str -> ( {model | raw <- str}, sendToRemote str )
        JsonData res ->
            case res of
                Result.Ok j -> ( { model | json <- j }, Effects.task (Task.succeed Ready))
                -- on error just leave the uploaded contents showing
                Result.Err e ->
                    ( { model | errorMessage <- converterErrorHandler e }, Effects.none )

converterErrorHandler : Http.Error -> String
converterErrorHandler err =
    case err of
        Http.UnexpectedPayload s -> s
        otherwise -> "http error"

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
    div [ class "upload row" ]
        [ div [ class "col-xs-6" ]
            [ English.intro
            , div []
                [ span [ class "btn btn-default btn-file" ]
                    [ text "Find file"
                    , input [ type' "file", id "input" ] [  ]
                    ]
                , button [ onClick address Upload, class "btn btn-primary" ] [ text "Upload" ]
                , div [ class "error-message" ] [ text model.errorMessage ]
                ]
            , button [ onClick address Demo, class "btn btn-success" ] [ text "Demo" ]
            ]
        ,  div [ class "img-container col-xs-6" ]
            [ img [ src "editor.png" ] [] ]
        ]

-- TASK : Read File

-- getTextFile : String -> Task FileReader.Error String
loadData : Effects Action
loadData =
    getTextFile "input" `Task.onError` (\err -> Task.succeed (readfileErrorHandler err))
        |> Task.map FileData
        |> Effects.task

readfileErrorHandler : FileReader.Error -> String
readfileErrorHandler err =
    case err of
        FileReader.ReadFail -> "File reading error"
        FileReader.NoFileSpecified -> "No file specified"


-- TASK - Converting to Json

-- post : Decoder value -> String -> Body -> Task Error value

rootUrl : String
-- rootUrl = "http://localhost:5000"
rootUrl = ""

sendToRemote : String -> Effects Action
sendToRemote raw =
    Http.post tcxDecoder (rootUrl ++ "/tcx") (Http.string <| "data=" ++ Http.uriEncode raw)
        |> Task.toResult
        |> Task.map JsonData
        |> Effects.task


getDemoData : Effects Action
getDemoData =
    Http.get tcxDecoder (rootUrl ++ "/tcx/demo")
        |> Task.toResult
        |> Task.map JsonData
        |> Effects.task

-- STYLES


-- -- -- --
    -- Http.post tcxDecoder "http://localhost:5000/tcx" (Http.string <| "data=test")
    -- Http.post tcxDecoder "http://localhost:5000/tcx" (Http.string """{ "xxxxsortBy": "xxxxxcoolness", "take": 10 }""")
    -- mypost
    -- Http.post tcxDecoder "http://localhost:5000/tcx/?data=testdata" (Http.string "")
    -- Http.post
        -- tcxDecoder ("http://localhost:5000/tcx?data=" ++ Http.uriEncode raw) (Http.string "")
-- mypost : Task Http.RawError Http.Response
-- mypost =
--   Http.send Http.defaultSettings
--     { verb = "POST"
--     , headers = [("content-type", "form-url-encoded")]
--     , url = "http://localhost:5000/tcx"
--     , body = (Http.string """{ "xxxxsortBy": "xxxxxcoolness", "take": 10 }""")
--     }
