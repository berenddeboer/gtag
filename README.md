# About

Google Analytics gtag framework support for Elm.


# JavaScript initialisation

Import in your `index.js` like:

```
import { GTag } from "../gtag/js/gtag.js"

const app = Elm.Main.init({node: document.getElementById("root")})
GTag.init(app)
```


# Usage

## Loading Google's gtag.js framework

You can either follow the [Google Analytics
instructions](https://developers.google.com/analytics/devguides/collection/gtagjs)
to load the library, but recommended is to do it all from Elm. There's
no need to burden your browser with loading Google Analytics while it
can spend time initialising and loading your application.

Your `init` should look something like:

```
import GTag

init : ( Model, Cmd Msg )
init =
  ( model, GTag.load "GA_MEASUREMENT_ID" )
```


## Telling Google Analytics about a new page view

Single App Frameworks won't automatically send an update to Google
Analytics when they are using fragment routing. There might also be
other cases which the Google Analytics framework does not detect. By
calling `GTag.pageView` you can tell Google Analytics exactly when
your page is changed.

In your `update` send the new page to Google Analytics when you
receive the `ChangedUrl` message for example:

```
import GTag

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =

  ChangedUrl url ->
    ( model, GTag.pageView "/my-name-page" )
```


## Support for other recommended events

The support for [recommended
events](https://developers.google.com/gtagjs/reference/event) is
rather limited at this moment. Supported are `login` and
`search`. Pull requests welcome!
