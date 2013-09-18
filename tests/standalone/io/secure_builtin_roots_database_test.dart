// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "package:expect/expect.dart";
import "package:path/path.dart";
import "dart:io";
import "dart:isolate";
import "dart:async";

void testGoogleUrl() {
  ReceivePort keepAlive = new ReceivePort();
  HttpClient client = new HttpClient();
  client.getUrl(Uri.parse('https://www.google.com'))
      .then((request) => request.close())
      .then((response)=> response.last)
      .then((_) {
        client.close();
        keepAlive.close();
      });
}

void InitializeSSL() {
  // If the built-in root certificates aren't loaded, the connection
  // should signal an error.  Even when an external database is loaded,
  // they should not be loaded.
  var certificateDatabase = join(dirname(Platform.script), 'pkcert');
  SecureSocket.initialize(database: certificateDatabase,
                          password: 'dartdart',
                          useBuiltinRoots: true);
}

void main() {
  InitializeSSL();
  testGoogleUrl();
}