module Msg exposing (..)

import File exposing (File)
import Tree exposing (NodeId)


type Msg
    = InsertFirstNode
    | InsertNodeAt NodeId String
    | SetNewNodeName String
    | SelectImage
    | ImageSelected File
    | ImageUrlSelected String
    | LoadSampleTree
