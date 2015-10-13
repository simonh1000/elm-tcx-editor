module Editor (Model, Action(..), update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Effects exposing (Effects)
import Task exposing (Task)
import Json.Decode as Json
import Date.Format exposing (format)
import Array exposing (Array)

import Upload
import TcxDecoder exposing (Lap, Trackpoint, Position)
import English
import SummaryInfo exposing (summaryInfo)

-- MODEL

type alias Model = Upload.Model
-- type alias Model =
--     { checked : Array (Array Bool)
--     , msg : String
--     }
--
-- init : List (TcxDecoder.Lap) -> Model
-- init data =
--     { checked = Array.fromList <| List.map (\lap -> Array.repeat (List.length lap - 1) False) data
--     , msg = ""
--     }

-- UPDATE

type Action =
      GotoUpload
    | MapLoaded
    | Click Int Int
    | Delete

update : Action -> Model -> (Model, Effects Action)
update action model = (model, Effects.none)
    -- let (Click lapIdx tpIdx) =

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
    div [ class "editor row" ]
        [ div [ class "col-xs-12" ] [ summaryInfo model.json ]
        , div [ class "col-xs-12" ]
            [ h2 [] [ text "Trackpoint data" ]
            , English.trackpoint
            ]
        , div [ class "col-xs-5 trackpoints" ] [ viewLaps address model.json ]
        , div [ class "col-xs-7" ]
            [ div [ id "map", onLoad address ] [] ]
        , div [ class "col-xs-12" ]
            [ button [ onClick address GotoUpload ] [ text "Load new data" ] ]
        ]

-- Sends message that map div exists and can be tageted from Javascript land
onLoad : Signal.Address Action -> Attribute
onLoad address =
    on "load" Json.value (\_ -> Signal.message address MapLoaded)

-- TcxDecoder.Model = List Lap
viewLaps : Signal.Address Action -> TcxDecoder.Model -> Html
viewLaps address laps =
    div [ class "laps" ] <|
        List.indexedMap (viewLap address) laps

viewLap : Signal.Address Action -> Int -> Lap -> Html
viewLap address lapIdx lap =
    div [ class "lap"]
        [ strong [] [ text <| "Lap " ++ toString lapIdx ]
        , table [] <|
            tr [ class "table-header" ]
                [ th [] [ text "Timestamp" ]
                , th [] [ text "Accum Dist." ]
                ]
            :: List.indexedMap (viewTP address lapIdx) lap.tps
        ]

viewTP : Signal.Address Action -> Int -> Int -> Trackpoint -> Html
viewTP address lapIdx tpIdx tp =
    tr [ class "track-point", onClick address (Click lapIdx tpIdx) ]
        [ td [] [ text <| format "%k:%M:%S" tp.time ]
        , td [] [ text <| (toString <| round tp.distance) ++ " m" ]
        ]
