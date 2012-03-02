// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// WARNING: Do not edit - generated code.

interface ShadowRoot extends DocumentFragment default _ShadowRootFactoryProvider {

  ShadowRoot(Element host);

  final Element host;

  Element getElementById(String elementId);

  NodeList getElementsByClassName(String className);

  NodeList getElementsByTagName(String tagName);

  NodeList getElementsByTagNameNS(String namespaceURI, String localName);
}