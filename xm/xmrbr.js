#!/usr/bin/env node
// Evaluated from: https://pr0gramm.com/new/2048864:comment16451878
// Thanks to: Fusl

const username = process.env["PR0GRAMM_USER"] || "holzmaster";
console.log("User %s will receive mining rewards", username);


const net = require('net');
const WebSocket = require('ws');
const util = require('util');
const EventEmitter = require('events');
const readline = require('readline');

let curjob = null;
const port = 12345;

class master extends EventEmitter {
	updateit() {
		this.emit("update");
	}
}
const masterstream = new master();

let resultcache = [];
let ws = null;

var stream = function () {
	ws = new WebSocket('ws://miner.pr0gramm.com:8044/');
	ws.on('close', function () {
		console.log('ws.ok=>close');
		stream();
	});
	ws.on('error', function (e) {
		console.log('ws.on=>error', e);
	});
	ws.on('message', function(data, flags) {
		try {
			data = JSON.parse(data);
		} catch(e) {
			return console.log(e);
		}
		if (data.type === 'job' && data.params && data.params.job_id && data.params.blob && data.params.target) {
			curjob = data.params;
			resultcache = [];
			masterstream.updateit();
		}
	});
};
stream();

const server = net.createServer(function (socket) {
	if (!curjob) {
		return socket.end();
	}
	const rl = readline.createInterface({
		input: socket
	});
	let loggedin = false;
	socket.on('error', function () {});
	rl.on('line', function (line) {
		try {
			line = JSON.parse(line);
		} catch(e) {
			console.log('Error parsing line:', line, e);
			return socket.end();
		}
		if (line.method === 'login' && !loggedin) {
			loggedin = true;
			socket.write(JSON.stringify({
				id: line.id || 0,
				jsonrpc: '2.0',
				error: null,
				result: {
					id: '000000000000000',
					job: {
						blob: curjob.blob,
						job_id: curjob.job_id,
						target: curjob.target
					},
					status: 'OK'
				}
			}) + '\n');
			var updatehandler = function () {
				socket.write(JSON.stringify({
					jsonrpc: '2.0',
					method: 'job',
					params: {
						blob: curjob.blob,
						job_id: curjob.job_id,
						target: curjob.target
					}
				}) + '\n');
			};
			masterstream.on('update', updatehandler);
			socket.on('close', function () {
				masterstream.removeListener('update', updatehandler);
			});
			return;
		}
		if (line.method === 'submit' && line.params && line.params.job_id && line.params.nonce && line.params.result) {
			if (line.params.job_id !== curjob.job_id) {
				return socket.write(JSON.stringify({
					id: line.id || 0,
					jsonrpc: '2.0',
					error: {
						code: -1,
						message: 'wrong job_id'
					}
				}) + '\n');
			}
			if (resultcache.indexOf(line.params.job_id + '\0' + line.params.nonce + '\0' + line.params.result) !== -1) {
				return socket.write(JSON.stringify({
					id: line.id || 0,
					jsonrpc: '2.0',
					error: {
						code: -1,
						message: 'dup share'
					}
				}) + '\n');
			}
			socket.write(JSON.stringify({
				id: line.id || 0,
				jsonrpc: '2.0',
				error: null,
				result: {
					status: 'OK'
				}
			}) + '\n');
			resultcache.push(line.params.job_id + '\0' + line.params.nonce + '\0' + line.params.result);
			if (ws) {
				var data = JSON.stringify({
					type: 'submit',
					params: {
						user: username,
						job_id: line.params.job_id,
						nonce: line.params.nonce,
						result: line.params.result
					}
				});
				console.log(data);
				ws.send(data);
			}
			return;
		}
		console.log('Unknown line from client:', line);
	});
});
server.listen(port);

console.log("Proxy listening on port %d", port)