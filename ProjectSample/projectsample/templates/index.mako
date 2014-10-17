<!DOCTYPE html>
<html lang="en" ng-app="app">
  <head>
    <title>Simple example</title>
    <meta charset="utf-8">
    <meta name="viewport"
          content="initial-scale=1.0, user-scalable=no, width=device-width">
    <meta name="apple-mobile-web-app-capable" content="yes">
% if debug:
    <link rel="stylesheet" href="/static/build/build-debug.css" type="text/css">
% else:
    <link rel="stylesheet" href="/static/build/build.css" type="text/css">
% endif
  </head>
  <body ng-controller="MainController">
    <div id="map" ngeo-map></div>
% if debug:
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.0/angular.js"></script>
    <script src="/closure/closure/goog/base.js"></script>
    <script src="/closure-deps.js"></script>
    <script src="/static/js/main.js"></script>
% else:
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.0/angular.min.js"></script>
    <script src="/static/build/build.js"></script>
% endif
  </body>
</html>
