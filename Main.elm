module TcxEditor where

import StartApp

import Effects exposing (Never)
import Task

import TcxDecoder exposing (Position)
import App exposing (AppState, Model, init, update, view)


app =
  StartApp.start
    { init = (init, Effects.none)
    , update = update
    , view = view
    , inputs = []
    }

main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

-- Tells JS whether to instantiate google maps
-- port gmap : Signal String
-- port gmap =
--     Signal.map (App.toString << .state) app.model

-- NEED TO REMOVE DUPLICATES
port gmap : Signal PortData
port gmap =
    Signal.dropRepeats <| Signal.map helper app.model

-- type alias PortData =
--     { state : AppState
--     , data : List Position
--     }

-- type alias TcxDecoder.Model = List Lap
type alias PortData = List Position

-- helper : App.Model -> PortData
-- helper model =
--     { state = model.state
--     , data = List.concatMap (List.map .position) model.data.json
--     }
helper : App.Model -> PortData
helper model =
    List.concatMap (List.map .position << .tps) model.data.json
