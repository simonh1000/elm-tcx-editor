module English (..) where
import Html exposing (..)
import Html.Attributes exposing (..)

intro : Html
intro =
    div []
        [ p [] [ text "Ever left your Garmin running at the end of a ride? All your hard earned averages declined pointlessly?" ]
        , p [] [ text "This simple editor enables you to delete points from a file, recalculates aggregate ride data, and returns a new copy of the file." ]
        , p [] [ text "To start, upload a '.tcx' file. You can convert a .fit file to .tcx using <a href='http://connect.garmin.com/'> Garmin Connect's</a> export functionality." ]
        , p [] [ text "<strong>Note:</strong> This app is tested with Edge 800 (firmware 2.6) data. YMMV, but other users (including with Garmin 610) report success." ]
        , p [] [ text "No copy of the data processed is kept." ]
        ]
