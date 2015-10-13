module SummaryInfo (summaryInfo) where

import Html exposing (..)
import Html.Attributes exposing (..)

import Upload
import TcxDecoder exposing (Lap, Trackpoint, Position)
import Date.Format exposing (format)


-- MODEL

type alias Model = TcxDecoder.Model -- List Lap


summaryInfo : Model -> Html
summaryInfo laps =
    let
        (lap1 :: _) = laps
    in div [class "summary"] <|
        h3 [] [ text <| "Summary of ride (" ++ format "%e %B %Y" lap1.startTime ++ ")" ]
        :: summaryHeader
        :: List.indexedMap lapSummary laps


summaryHeader : Html
summaryHeader =
    div [ class "row headers" ]
        [ div [ class "col-xs-2" ] [ ]
        , div [ class "col-xs-2" ] [ text "start"]
        -- , div [ class "col-xs-2" ] [ text "end"]
        , div [ class "col-xs-2" ] [ text "totalTime" ]
        , div [ class "col-xs-2" ] [ text "distance" ]
        , div [ class "col-xs-2" ] [ text "Avg speed"]
        ]

lapSummary : Int -> Lap -> Html
lapSummary lapIdx lap =
    div [ class "row lap" ]
        [ div [ class "col-xs-2" ] [ text <| "Lap " ++ toString lapIdx ]
        , div [ class "col-xs-2" ] [ text <| format "%k:%M:%S" lap.startTime ]
        -- , div [ class "col-xs-2" ] [ text "end"]
        , div [ class "col-xs-2" ] [ text <| (toString <| round lap.totalTime) ++ " s" ]
        , div [ class "col-xs-2" ] [ text <| (toString <| roundFloat 2 (lap.distance / 1000)) ++ " km" ]
        , div [ class "col-xs-2" ] [ text <| (toString <| roundFloat 1 (toKmh lap.averageSpeed)) ++ " km/h"]
        ]

roundFloat : Int -> Float -> Float
roundFloat n x =
    let nn = toFloat <| 10 ^ n
    in (toFloat <| round (x * nn)) / nn

toKmh : Float -> Float
toKmh ms = ms * 60 * 60 / 1000
