// var express = require('express');
// var app = express();
//
// app.get('/', function (req, res) {
//   res.send('Hello World!');
// });
//
// app.listen(3000, function () {
//   console.log('Example app listening on port 3000!');
// });
//

var app = require('http').createServer(handler);
var io = require('socket.io').listen(app);
var fs = require('fs');

app.listen(3000);

// http server - a propery http server should handle this
function handler (req, res) {
	fs.readFile(__dirname + '/chat.html',
		function (err, data) {
			if (err) {
				res.writeHead(500);
				return res.end('Error loading file');
			}
			res.writeHead(200);
			res.end(data);
		}
	);
}

// User connects
// TODO limit connected clients
var chat = io.sockets.on('connection', function onConnect(socket) {

	// This var is in the scope of the socket.  The room is tracked by each subscribed socket.
	var roomName;

	socket.on('subscribe', subscribe);
	socket.on('set handle', changeHandle);
	socket.on('disconnect', disconnect);
	socket.on('message', receiveMessage);

	// socket subscribes to room
	function subscribe (data) {
		roomName = data.room;
		socket.join(roomName);
		socket.set('handle', data.handle, function () {
			handleUpdated(data.handle);
			sendSystemMessage(data.handle + ' has joined');
		});
	}

	// Change handle
	// TODO we should escape or otherwise disable special characters.  Maybe client side
	function changeHandle(newHandle) {
		// Get current handle for client
		socket.get('handle', function(err, oldHandle) {
			// Set new handle for client
			socket.set('handle', newHandle, function handleSet() {
				handleUpdated(newHandle);
				sendSystemMessage(oldHandle + ' is now called ' + newHandle);
			});
		});
	}

	// Common code when socket handle is updated
	function handleUpdated(handle) {
		socket.emit('my handle updated', handle);
		updateHandles();
	}

	// get a property for each client in a room
	function getAll(field, callback) {
		var allHandles = [];
		// all sockets in room
		var sockets = io.sockets.clients(roomName);
		for(var index = 0; index < sockets.length; index++) {
			sockets[index].get(field, function(error, handle) {
				// If error, is handle undefined?  May want to check this
				allHandles.push(handle);
				// get() is async.  Don't invoke callback until it seems we are on the last one
				// There is a risk that an error occurs, and so this will not always fire
				if(allHandles.length == sockets.length) {
					callback(allHandles);
				}
			});
		}
	}

	// Inform all clients that someone's user handle has changed
	// TODO this could be inefficient in a huge room.  Maybe enforce connected client max or figure our how to keep track of connected clients within scope of room
	function updateHandles() {
		getAll('handle', function(allHandles) {
			io.sockets.in(roomName).emit('a handle was updated', allHandles);
		});
	}

	// Send a message to all connected clients
	function sendMessage(handle, message) {
		var messageOut = {
			handle: handle,
			body: message
		};
		io.sockets.in(roomName).emit('message', messageOut);
	}

	// Send system message to all connected clients from user 'system'
	function sendSystemMessage(message) {
		sendMessage('system', message);
	}

	function disconnect() {
		socket.get('handle', function(err, handle) {
			// must leave room before doing this or socket will still be in list of connected clients
			socket.leave(roomName);
			updateHandles();
			sendSystemMessage(handle + ' disconnected');
		})
	}

	function receiveMessage(messageIn) {
		socket.get('handle', function (err, handle) {
			sendMessage(handle, messageIn);
		});
	}
});
