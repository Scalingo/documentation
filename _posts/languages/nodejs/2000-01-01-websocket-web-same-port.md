---
title: Socket.IO and Express server listening on the same port
nav: Socket.IO and Express on the same port
tags: nodejs
index: 3
---

On Scalingo, your application must listen to the port defined in the `PORT` environment variable the
platform dynamically defines.

If your application uses both a HTTP server and a WebSocket, you can configure it to use the same
port. Here is a snippet to do that with an Express server and Socket.IO for the WebSocket part:

```js
var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

app.use(express.static(__dirname + '/node_modules'));
app.get('/', function(req, res,next) {
   res.sendFile(__dirname + '/index.html');
});

server.listen(process.env.PORT || 4200);

io.on('connection', function(client) {
   console.log('Client connected...');

   client.on('join', function(data) {
       console.log(data);
   });
})
```
