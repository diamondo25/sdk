// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "package:expect/expect.dart";
import "dart:io";
import "dart:isolate";
import "dart:async";

void testGoogleUrl() {
  // We need to use an external server here because it is backed by a
  // built-in root certificate authority.
  InternetAddress.lookup('www.google.com').then((_) {
    ReceivePort keepAlive = new ReceivePort();
    HttpClient client = new HttpClient();
    client.getUrl(Uri.parse('https://www.google.com'))
        .then((request) => request.close())
        .then((response) => Expect.fail("Unexpected successful connection"))
        .catchError((error) {
          Expect.isTrue(error is HandshakeException);
          keepAlive.close();
          client.close();
        });
  },
  onError: (e) {
    Expect.isTrue(e is SocketException);
  });
}

void InitializeSSL() {
  // If the built-in root certificates aren't loaded, the connection
  // should signal an error.
  SecureSocket.initialize(useBuiltinRoots: false);
}

void main() {
  InitializeSSL();
  testGoogleUrl();
}