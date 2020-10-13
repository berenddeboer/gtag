"use strict";

/**
 * Thin interface between Elm and gtag().
 *
 * We allow Elm to determine if gtag is loaded as well.
 */

const GTag = {
  init: app => {
    window.dataLayer = window.dataLayer || []
    window.gtag = function (){dataLayer.push(arguments)}
    gtag('js', new Date())

    if (typeof app.ports === "undefined")
      return

    app.ports.gload && app.ports.gload.subscribe(function(message) {
      const script = document.createElement('script');
      script.src = "https://www.googletagmanager.com/gtag/js?id=" + message.measurementId
      document.body.append(script)
      gtag('config', message.measurementId, { 'send_page_view': message.sendPageView })
    })
    app.ports.gconfig && app.ports.gconfig.subscribe(function(message) {
      gtag ("config", message.measurementId, message.params)
    })
    app.ports.gevent && app.ports.gevent.subscribe(function(message) {
      gtag ("event", message.eventName, message.params)
    })
    app.ports.gset && app.ports.gset.subscribe(function(message) {
      gtag ("set", message.keyValuePairs)
    })
  }
}

export { GTag }
