module Main exposing (..)

import Browser exposing (Document)
import File
import File.Select as Select
import Html exposing (..)
import Html.Attributes as A
import Html.Events as E
import Msg exposing (..)
import Task
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
    = NoTree { newNodeName : String, newImageUrl : String }
    | YesTree { tree : Node, newNodeName : String, newImageUrl : String }


sampleTree : Node
sampleTree =
    Node { id = "a", name = "Granny", image = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fdl6pgk4f88hky.cloudfront.net%2F2021%2F06%2F2020_22_camus-scaled.jpg&f=1&nofb=1&ipt=06c6ff4e019c9838853189ca94b8d1a9e96f90521047aa365a5b8371fb7a3ec3", children = [] }
        |> Tree.insertAt (Node { id = "b", name = "Daddy", image = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.blackenterprise.com%2Fwp-content%2Fblogs.dir%2F1%2Ffiles%2F2023%2F09%2FGettyImages-1498324323-scaled-1-1920x1280.jpg&f=1&nofb=1&ipt=248b45c934eecd4c08d2f6ea9b61f8a5d64bb1ee79ea5eb4af1e5038e5e5a2ab", children = [] }) "a"
        |> Tree.insertAt (Node { id = "c", name = "Mommy", image = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.irishexaminer.com%2Fcms_media%2Fmodule_img%2F4665%2F2332535_6_seoimage4x3_GettyImages-1154321514_1_.jpg&f=1&nofb=1&ipt=37b410918142ca445523e316f91f39de5c1795f1351ec6dccb7891ef86ee20e0", children = [] }) "a"
        |> Tree.insertAt (Node { id = "d", name = "Brutha", image = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fstatic0.gamerantimages.com%2Fwordpress%2Fwp-content%2Fuploads%2F2023%2F02%2Faoi-todo.jpg&f=1&nofb=1&ipt=49ca955cc250725c28c1079d462f96b1fce4de67f70d771cd441e6e411660193", children = [] }) "b"


init : () -> ( Model, Cmd Msg )
init () =
    ( NoTree { newNodeName = "", newImageUrl = "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( InsertFirstNode, NoTree m ) ->
            ( YesTree
                { newNodeName = ""
                , newImageUrl = ""
                , tree = Node { id = m.newNodeName, name = m.newNodeName, image = m.newImageUrl, children = [] }
                }
            , Cmd.none
            )

        ( SetNewNodeName name, NoTree m ) ->
            ( NoTree { m | newNodeName = name }, Cmd.none )

        ( SetNewNodeName name, YesTree m ) ->
            ( YesTree { m | newNodeName = name }, Cmd.none )

        ( InsertNodeAt id name, YesTree m ) ->
            ( YesTree
                { m
                    | tree = Tree.insertAt (Node { id = name, name = name, children = [], image = m.newImageUrl }) id m.tree
                    , newNodeName = ""
                    , newImageUrl = ""
                }
            , Cmd.none
            )

        ( SelectImage, _ ) ->
            ( model, Select.file [ "image/png", "image/jpeg" ] ImageSelected )

        ( ImageSelected file, _ ) ->
            ( model, Task.perform ImageUrlSelected <| File.toUrl file )

        ( ImageUrlSelected url, NoTree m ) ->
            ( NoTree { m | newImageUrl = url }, Cmd.none )

        ( ImageUrlSelected url, YesTree m ) ->
            ( YesTree { m | newImageUrl = url }, Cmd.none )

        ( LoadSampleTree, _ ) ->
            ( YesTree { tree = sampleTree, newImageUrl = "", newNodeName = "" }, Cmd.none )

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
            , button [ E.onClick LoadSampleTree ] [ text "Cargar árbol de ejemplo" ]
            , h2 [] [ text "Crea tu árbol genealógico" ]
            , howToUse
            , inputBox model
            , imageButton model
            , treePage model
            ]
        ]
    }


howToUse : Html Msg
howToUse =
    div []
        [ h3 [] [ text "¿Cómo usar esta m?" ]
        , p [] [ text "1. Ingresa el nombre del miembro y una imagen" ]
        , p [] [ text "2. Haz clic en el + de la bolita a la que le quieres dar un hijo" ]
        , small [] [ text "No se puede borrar, así que no te equivoques" ]
        ]


imageButton : Model -> Html Msg
imageButton model =
    let
        btn =
            button [ E.onClick SelectImage ] [ text "Escoge una imagen" ]

        el m =
            if m.newImageUrl /= "" then
                div [] [ btn, span [] [ text "¡Imagen cargada!" ] ]

            else
                div [] [ btn ]
    in
    case model of
        NoTree m ->
            el m

        YesTree m ->
            el m


inputBox : Model -> Html Msg
inputBox model =
    case model of
        NoTree m ->
            div []
                [ input [ A.value m.newNodeName, E.onInput SetNewNodeName, A.placeholder "Nombre..." ] []
                , button [ E.onClick InsertFirstNode ] [ text "+" ]
                ]

        YesTree m ->
            div []
                [ input [ A.value m.newNodeName, E.onInput SetNewNodeName, A.placeholder "Nombre..." ] []
                ]


treePage : Model -> Html Msg
treePage model =
    case model of
        NoTree _ ->
            div [] []

        YesTree m ->
            ViewTree.renderTree m.newNodeName m.tree
