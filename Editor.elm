module Editor (Model, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Effects exposing (Effects)
import Task exposing (Task)

import Date.Format exposing (format)
import Upload
import TcxDecoder exposing (Lap, Trackpoint, Position)

-- MODEL

type alias Model = Upload.Model

-- UPDATE

type Action =
      Parsed Model
    | Click

update : Action -> Model -> (Model, Effects Action)
update action model = (model, Effects.none)

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
    div [ class "row" ]
        [ div [ class "col-xs-12" ]
            [ h2 [] [ text "Editor" ] ]
        , div [ class "data-table col-xs-6" ] <|
            viewLaps address model.json
        , div [id "map", class "col-xs-6"] []
        ]

-- TcxDecoder.Model = List Lap
viewLaps : Signal.Address Action -> TcxDecoder.Model -> List Html
viewLaps address laps =
        List.map (viewLap address) laps

viewLap : Signal.Address Action -> Lap -> Html
viewLap address lap =
    table [] <|
        tr []
            [ th [] [ text "Time" ]
            , th [] [ text "Distance" ]
            ]
        :: List.map (viewTP address) lap.tps

viewTP : Signal.Address Action -> Trackpoint -> Html
viewTP address tp =
    tr [ onClick address Click ]
        [ td [] [ text <| format "%k:%M:%S" tp.time ]
        , td [] [ text <| toString <| round tp.distance ]
        ]
