module Main exposing (..)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes as A
import Html.Events as E
import Msg exposing (..)
import Tree exposing (Node(..))
import ViewTree


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Model
    = NoTree { newNodeName : String }
    | YesTree { tree : Node, newNodeName : String }


sampleTree : Node
sampleTree =
    Node { id = "a", name = "Granny", image = Nothing, children = [] }
        |> Tree.insertAt (Node { id = "b", name = "Daddy", image = Nothing, children = [] }) "a"
        |> Tree.insertAt (Node { id = "c", name = "Mommy", image = Nothing, children = [] }) "a"
        |> Tree.insertAt (Node { id = "d", name = "Brutha", image = Nothing, children = [] }) "b"


init : () -> ( Model, Cmd Msg )
init () =
    ( NoTree { newNodeName = "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( InsertFirstNode, NoTree m ) ->
            ( YesTree
                { newNodeName = ""
                , tree = Node { id = m.newNodeName, name = m.newNodeName, image = Nothing, children = [] }
                }
            , Cmd.none
            )

        ( SetNewNodeName name, NoTree { newNodeName } ) ->
            ( NoTree { newNodeName = name }, Cmd.none )

        ( SetNewNodeName name, YesTree m ) ->
            ( YesTree { m | newNodeName = name }, Cmd.none )

        ( InsertNodeAt id name, YesTree { tree, newNodeName } ) ->
            ( YesTree
                { tree = Tree.insertAt (Node { id = name, name = name, children = [], image = Nothing }) id tree
                , newNodeName = newNodeName
                }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Document Msg
view model =
    { title = "Treecko"
    , body =
        [ main_ []
            [ h1 [] [ text "Treecko" ]
            , h2 [] [ text "Crea tu árbol genealógico" ]
            , inputBox model
            , treePage model
            ]
        ]
    }


inputBox : Model -> Html Msg
inputBox model =
    case model of
        NoTree _ ->
            div []
                [ input [ E.onInput SetNewNodeName, A.placeholder "Nombre..." ] []
                , button [ E.onClick InsertFirstNode ] [ text "+" ]
                ]

        YesTree _ ->
            input [ E.onInput SetNewNodeName, A.placeholder "Nombre..." ] []


treePage : Model -> Html Msg
treePage model =
    case model of
        NoTree _ ->
            div [] []

        YesTree m ->
            ViewTree.renderTree m.newNodeName m.tree
