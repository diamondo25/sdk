// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library custom_elements_name_clash;

import 'dart:html';

class CustomElement extends HtmlElement {
  factory CustomElement() => new Element.tag('x-custom');

  CustomElement.created() : super.created() {
  }

  // Try to clash with native 'appendChild' method.
  var appendChild = 123;
}

main() {
  document.registerElement('x-custom', CustomElement);
  CustomElement custom = new CustomElement();
  document.body.children.add(custom);
  // Will call appendChild in JS.
  custom.children.add(new DivElement()..text = 'Hello world!'); 
}