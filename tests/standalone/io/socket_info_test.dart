// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:io";

import 'package:async_helper/async_helper.dart';
import "package:expect/expect.dart";

void testHostAndPort() {
  asyncStart();
  ServerSocket.bind("127.0.0.1", 0).then((server) {

    Socket.connect("127.0.0.1", server.port).then((clientSocket) {
      server.listen((socket) {
        Expect.equals(socket.port, server.port);
        Expect.equals(clientSocket.port, socket.remotePort);
        Expect.equals(clientSocket.remotePort, socket.port);
        Expect.equals(socket.remoteAddress.address, "127.0.0.1");
        Expect.equals(clientSocket.remoteAddress.address, "127.0.0.1");
        socket.destroy();
        clientSocket.destroy();
        server.close();
        asyncEnd();
      });
    });
  });
}

void withTempDir(String prefix, void test(Directory dir)) async {
  var tempDir = Directory.systemTemp.createTempSync(prefix);
  try {
    await test(tempDir);
  } finally {
    tempDir.deleteSync(recursive: true);
  }
}

Future testHostAndPortUds(Directory dir) async {
  asyncStart();
  var address = new UnixDomainAddress('${dir.path}/xxx');
  var server = await ServerSocket.bind(address, 0);
  var client = await Socket.connect(address, server.port);
  server.listen((socket) {
    Expect.equals(socket.port, 1);
    Expect.equals(socket.port, server.port);
    Expect.equals(client.port, socket.remotePort);
    Expect.equals(client.remotePort, socket.port);
    Expect.isTrue(socket.remoteAddress is UnixDomainAddress);
    Expect.equals(socket.remoteAddress.path, '.');
    Expect.equals(client.remoteAddress.path, address.path);
    socket.destroy();
    client.destroy();
    server.close();
    asyncEnd();
  });
}

void main() {
  testHostAndPort();
  if (!Platform.isWindows) {
    withTempDir('socket_info_test', testHostAndPortUds);
  }
}
