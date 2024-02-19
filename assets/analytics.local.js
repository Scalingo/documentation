/* eslint-disable no-console */
/* Last update: 2023-11-23 */
function setupLocalAnalytics() {
  "use strict";

  var location = window.location;
  var document = window.document;

  var scriptEl = document.currentScript;
  var endpoint = scriptEl.getAttribute("data-api") || defaultEndpoint(scriptEl);

  function onIgnoredEvent(reason, options) {
    if (reason) console.warn("Ignoring Event: " + reason);
    options && options.callback && options.callback();
  }

  function defaultEndpoint(el) {
    return new URL(el.src).origin + "/api/event";
  }

  function trigger(eventName, options) {
    try {
      if (window.localStorage.plausible_ignore === "true") {
        return onIgnoredEvent("localStorage flag", options);
      }
      // eslint-disable-next-line no-empty
    } catch (e) {}

    var payload = {};
    payload.n = eventName;
    payload.u = location.href;
    payload.d = scriptEl.getAttribute("data-domain");
    payload.r = document.referrer || null;
    if (options && options.meta) {
      payload.m = JSON.stringify(options.meta);
    }
    if (options && options.props) {
      payload.p = options.props;
    }

    var propAttributes = scriptEl.getAttributeNames().filter(function (name) {
      return name.substring(0, 6) === "event-";
    });

    var props = payload.p || {};

    propAttributes.forEach(function (attribute) {
      var propKey = attribute.replace("event-", "");
      var propValue = scriptEl.getAttribute(attribute);
      props[propKey] = props[propKey] || propValue;
    });

    payload.p = props;

    var request = new XMLHttpRequest();
    request.open("POST", endpoint, true);
    request.setRequestHeader("Content-Type", "text/plain");

    request.send(JSON.stringify(payload));

    request.onreadystatechange = function () {
      if (request.readyState === 4) {
        options && options.callback && options.callback();
      }
    };
  }

  var queue = (window.plausible && window.plausible.q) || [];
  window.plausible = trigger;
  for (var i = 0; i < queue.length; i++) {
    trigger.apply(this, queue[i]);
  }

  var lastPage;

  function page() {
    if (lastPage === location.pathname) return;
    lastPage = location.pathname;
    trigger("pageview");
  }

  var his = window.history;
  if (his.pushState) {
    var originalPushState = his["pushState"];
    his.pushState = function () {
      originalPushState.apply(this, arguments);
      page();
    };
    window.addEventListener("popstate", page);
  }

  function handleVisibilityChange() {
    if (!lastPage && document.visibilityState === "visible") {
      page();
    }
  }

  if (document.visibilityState === "prerender") {
    document.addEventListener("visibilitychange", handleVisibilityChange);
  } else {
    page();
  }
}

setupLocalAnalytics();
