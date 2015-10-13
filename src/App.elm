module App (Action(..), Model, AppState, init, update, view, toString) where

import Html exposing (..)
import Html.Attributes exposing (..)

import Effects exposing (Effects)

import Upload exposing (Action(..))
import Editor exposing (Action(..))
import TcxDecoder exposing (Model)

-- MODEL
type AppState =
      Uploading
    | Transitioning
    | Editing
    | ErrorState

toString : AppState -> String
toString a =
    case a of
        Uploading -> "Uploading"
        Transitioning -> "Transitioning"
        Editing -> "Editing"
        ErrorState -> "Error"

type alias Model =
    { state : AppState
    , data : Upload.Model
    -- , editor : Editor.Model
    , zoom : Int
    }

init : Model
init =
    { state = Uploading
    , data = Upload.init
    -- , editor = Editor.init []
    , zoom = 12
    }

-- UPDATE

type Action =
      Uploader Upload.Action
    | Editor Editor.Action
    | MapLoaded
    | SetZoom Int

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Uploader Ready -> ({ model | state <- Editing }, Effects.none)
        Uploader data ->                                 -- i.e. otherwise pass raw data for conversion
            let
                tmp = Upload.update data model.data
                newModel =
                    { model | data <- fst tmp
                    }
            in (newModel, Effects.map Uploader (snd tmp))  -- wrap uploaders effect top level Action
        Editor editorAction -> -- (model, Effects.none)
            case editorAction of
                GotoUpload -> (
                    { model | state <- Uploading
                            ,  data <- Upload.init
                    }, Effects.none)
                otherwise -> ( model, Effects.none)
        SetZoom z -> ( { model | zoom <- z }, Effects.none )
        -- otherwise ->
        --     let newModel =
        --         { model | state <- ErrorState }
        --     in (newModel, Effects.none)

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
            , div [ class "logo-container" ] 
                [ a [ href "http://www.elm-lang.org" ]
                    [ img [ src "ElmLogo.png" ] []
                    , p [] [ text "Built with Elm" ]
                    ]
                ]
            ]
