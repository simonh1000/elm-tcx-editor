module Processor (Model, Action, init, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Http

import Effects exposing (Effects)
import Task exposing (Task)

import TcxDecoder exposing (Model, tcxDecoder)

-- MODEL

type alias Model = TcxDecoder.Model

init : Model
init = []

-- UPDATE

type Action =
    Parsed Model

update : Action -> Model -> (Model, Effects Action)
update action model = (model, Effects.none)

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ p [ ] [ text "Processing" ]
        ]
