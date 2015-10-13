module TcxEditor where

import StartApp

import Effects exposing (Never)
import Task

import TcxDecoder exposing (Position)
import App exposing (Action(..), Model, init, update, view)


app =
  StartApp.start
    { init = (init, Effects.none)
    , update = update
    , view = view
    , inputs = [Signal.map SetZoom zoom]
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

port mapdiv : Signal String
port mapdiv =
    Signal.dropRepeats <| Signal.map (toString << .state) app.model

--

type alias PortData = List Position

port gmap : Signal PortData
port gmap =
    Signal.dropRepeats <| Signal.map helper app.model

helper : App.Model -> PortData
helper model =
    let
        skipRate = round <| -3.4 * (toFloat model.zoom) + 66
        fullList = List.concatMap (List.map .position << .tps) model.data.json
    in indexedFilter (\i _ -> i % skipRate == 0) fullList  -- show only every 20th

indexedFilter : (Int -> a -> Bool) -> List a -> List a
indexedFilter p xs =
    let
        tup = List.map2 (,) [ 0 .. List.length xs - 1 ] xs
    in List.foldr (\(i,x) acc -> if p i x then x :: acc else acc) [] tup


-- Zoom handler
port zoom : Signal Int




-- helper : App.Model -> PortData
-- helper model =
--     { state = model.state
--     , data = List.concatMap (List.map .position) model.data.json
--     }
