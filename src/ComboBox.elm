module ComboBox exposing (..)

import Html exposing (Html, div, hr, input)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onInput)


type alias Model =
    { selected : List String
    , suggestions : List Option
    , search : String
    }


type alias Option =
    { label : String
    , id : String
    }


init : List String -> Model
init selected =
    { selected = selected
    , suggestions = []
    , search = ""
    }


type Msg
    = Toggle String
    | Search String


type alias Config =
    { multi : Bool
    , options : List Option
    , viewSuggestion : Msg -> String -> Html Msg
    , viewSelected : Msg -> String -> Html Msg
    }


update : Config -> Msg -> Model -> Model
update { multi, options } msg model =
    case msg of
        Toggle s ->
            let
                selected =
                    if multi then
                        if List.member s model.selected then
                            List.filter ((/=) s) model.selected

                        else
                            s :: model.selected

                    else
                        case model.selected of
                            [ t ] ->
                                if t == s then
                                    []

                                else
                                    [ s ]

                            _ ->
                                [ s ]
            in
            { model | selected = selected }

        Search s ->
            let
                suggestions =
                    List.filter (\{ label } -> String.contains s label) options
            in
            { model
                | suggestions = suggestions
                , search = s
            }


view : Config -> Model -> Html Msg
view { options, viewSuggestion, viewSelected } { search, selected, suggestions } =
    div []
        [ input [ type_ "text", placeholder "Search", onInput Search, value search ] []
        , if search == "" then
            div [] <| List.map (\{ label, id } -> viewSuggestion (Toggle id) label) options

          else
            div [] <| List.map (\{ label, id } -> viewSuggestion (Toggle id) label) suggestions
        , hr [] []
        , div [] <| List.map (\s -> viewSelected (Toggle s) s) selected
        ]
