module TcxEditor where

import StartApp

import Effects exposing (Never)
import Task

import App exposing (init, update, view)


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
port gmap : Signal Bool
port gmap = Signal.map .loadMap app.model
