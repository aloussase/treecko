module Msg exposing (..)

import Tree exposing (NodeId)


type Msg
    = InsertFirstNode
    | InsertNodeAt NodeId String
    | SetNewNodeName String
