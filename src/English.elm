module English (..) where

import Html exposing (..)
import Html.Attributes exposing (..)

intro : Html
intro =
    div []
        [ p [] [ text "Ever left your Garmin running at the end of a ride? All your hard earned averages declined pointlessly?" ]
        , p [] [ text "This simple editor enables you to delete points from a file, recalculates aggregate ride data, and returns a new copy of the file." ]
        , p []
            [ text "To start, upload a '.tcx' file. You can convert a .fit file to .tcx using "
            , a [ href "http://connect.garmin.com/" ] [ text "Garmin Connect's" ]
            , text " export functionality."
            ]
        , p []
            [ strong [] [ text "Note: " ]
            , text "This app is tested with Edge 800 (firmware 2.6) data. YMMV, but other users (including with Garmin 610) report success."
            ]
        , p [] [ text "No copy of the data processed is kept." ]
        ]

trackpoint : Html
trackpoint =
    p [] [ text "Choose 'trackpoints' to delete from the rows below or click on the map (not the markers). Use Shift+Click to select multiple rows." ]
