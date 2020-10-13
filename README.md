# About

Google Analytics gtag.js support for Elm.


# Initialisation

Import in your `index.js` like:

```
import { GTag } from "../gtag/js/gtag.js"

const app = Elm.Main.init({node: document.getElementById("root")})
GTag.init(app)
```


# Usage

## Loading the gtag library

Your `init` should look something like:

```
init : ( Model, Cmd Msg )
init =
  ( model, GTag.load "GA_MEASUREMENT_ID" )
```


## Updating page view

In your `update` send the new page to Google Analytics when you receive the `ChangedUrl` message for example:

```
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =

  ChangedUrl url ->
    ( model, GTag.pageView "/my-name-page" )
```
