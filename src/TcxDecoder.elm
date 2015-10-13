module TcxDecoder (tcxDecoder, Model, Lap, Trackpoint, Position) where

import Json.Decode as Json exposing (..)
import String exposing (toInt, toFloat)
import Date exposing (Date)
import Result

type alias Model = List Lap

type alias Lap =
    { startTime : Date
    , totalTime: Float
    , distance: Float
    -- max speed
    -- calories
    , tps: List Trackpoint
    , averageSpeed : Float
    }

type alias Trackpoint =
    -- { time: String
    { time: Date
    , position: Position
    , distance: Float
    }

type alias Position =
    { lat: Float
    , lng: Float
    }

tcxDecoder : Decoder Model
tcxDecoder =
    -- at ["TrainingCenterDatabase", "Activities"] <| object1 (\[x] -> x) (list activitiesDecoder)
    at ["TrainingCenterDatabase", "Activities"] <| tuple1 identity activitiesDecoder

activitiesDecoder : Decoder Model
-- activitiesDecoder = xtract "Activity" activityDecoder
activitiesDecoder = ("Activity" := tuple1 identity activityDecoder)

activityDecoder : Decoder Model
activityDecoder = ("Lap" := list lapDecoder)

-- customDecoder : Decoder a -> (a -> Result String b) -> Decoder b
-- toFloat : String -> Result String Float
lapDecoder: Decoder Lap
lapDecoder =
    object5 Lap
        (at ["$"] (customDecoder ("StartTime" := string) Date.fromString))
        (xtractFloat "TotalTimeSeconds")
        (xtractFloat "DistanceMeters")
        trackDecoder
        extensionsDecoder


trackDecoder: Decoder (List Trackpoint)
trackDecoder = "Track" := tuple1 identity ("Trackpoint" := list tpDecoder)

tpDecoder : Decoder Trackpoint
tpDecoder =
    object3 Trackpoint
        (xtractDate "Time")
        -- ("Time" := tuple1 identity string)
        ("Position" := tuple1 identity posDecoder)
        (xtractFloat "DistanceMeters")

extensionsDecoder : Decoder Float
extensionsDecoder = "Extensions" := tuple1 identity lxDecoder

lxDecoder : Decoder Float
lxDecoder = "LX" := tuple1 identity (xtractFloat "AvgSpeed")

posDecoder: Decoder Position
posDecoder =
    object2 Position
        (xtractFloat "LatitudeDegrees")
        (xtractFloat "LongitudeDegrees")

-- apply decoder to singleton array
-- xtract : String -> Decoder a -> Decoder a
-- xtract s d = object1 (\[x] -> x) (s := list d)
-- xtract s d = (s:= tuple1 identity d)

xtractFloat: String -> Decoder Float
xtractFloat str = customDecoder (str := tuple1 identity string) String.toFloat

xtractDate: String -> Decoder Date
xtractDate fieldname = customDecoder (fieldname := tuple1 identity string) Date.fromString
