---
title: Socket.IO and Express server listening on the same port
nav: Socket.IO and Express on the same port
modified_at: 2020-12-03 00:00:00
tags: nodejs
index: 100
---

On Scalingo, your application must listen to the port defined in the `PORT` environment variable dynamically defined by the platform.

If your application uses both a HTTP server and a WebSocket, you can configure it to use the same port. A complete sample is deployed [here](https://node-socketio.is-easy-on-scalingo.com) with the code being publicly available in this [GitHub repository](https://github.com/Scalingo/sample-node-socketio). Here is a snippet to do that with an Express server and Socket.IO for the WebSocket part:

```js
var express = require('express')
var app = express()
var http = require('http').createServer(app);
var io = require('socket.io')(http);

app.get('/', function (req, res) {
  res.sendFile(__dirname + '/index.html');
});

http.listen(process.env.PORT || 3000, function() {
  var host = http.address().address
  var port = http.address().port
  console.log('App listening at http://%s:%s', host, port)
});

io.on('connection', function(socket) {
  console.log('Client connected to the WebSocket');

  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });

  socket.on('chat message', function(msg) {
    console.log("Received a chat message");
    io.emit('chat message', msg);
  });
})
```
