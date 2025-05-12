module ViewTree exposing (renderTree)

import Html exposing (..)
import Html.Attributes as A
import Html.Events as E
import Msg
import Tree exposing (Node(..))


renderTree : String -> Node -> Html Msg.Msg
renderTree newNodeName (Node root) =
    div []
        [ div [ A.class "parent" ]
            [ span [] [ text root.name ]
            , button [ E.onClick (Msg.InsertNodeAt root.id newNodeName) ] [ text "+" ]
            ]
        , div
            [ A.class "children" ]
            (List.map
                (\c -> renderTree newNodeName c)
                root.children
            )
        ]
