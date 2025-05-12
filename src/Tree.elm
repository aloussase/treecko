module Tree exposing (..)

import File exposing (File)


type alias NodeId =
    String


type Node
    = Node
        { id : NodeId
        , name : String
        , image : Maybe File
        , children : List Node
        }


insertAt : Node -> NodeId -> Node -> Node
insertAt new_node node_id (Node root) =
    if root.id == node_id then
        Node { root | children = new_node :: root.children }

    else
        let
            new_children =
                List.map (\c -> insertAt new_node node_id c) root.children
        in
        Node { root | children = new_children }


isEqualTo : Node -> Node -> Bool
isEqualTo (Node n) (Node m) =
    if n.id /= m.id then
        False

    else if List.length n.children == List.length m.children then
        List.map2 isEqualTo n.children m.children
            |> List.all (\b -> b == True)

    else
        False
