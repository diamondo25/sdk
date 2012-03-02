// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

package com.google.dart.compiler.backend.js;

import com.google.dart.compiler.ast.DartFunction;
import com.google.dart.compiler.ast.DartNode;
import com.google.dart.compiler.ast.DartUnit;
import com.google.dart.compiler.backend.js.ast.JsFunction;
import com.google.dart.compiler.backend.js.ast.JsProgram;
import com.google.dart.compiler.backend.js.ast.JsScope;
import com.google.dart.compiler.resolver.Element;
import com.google.dart.compiler.resolver.LibraryElement;

import java.util.HashMap;
import java.util.Map;

/**
 * Information generated by {@link GenerateNamesAndScopes} and consumed by
 * {@link GenerateJavascriptAST}.
 */
public class TranslationContext {
  private final DartMangler mangler;
  private final Map<Element, JsScope> memberScopes = new HashMap<Element, JsScope>();
  private final Map<DartFunction, JsFunction> methods = new HashMap<DartFunction, JsFunction>();
  private final JsNameProvider names;
  private final JsProgram program;

  private TranslationContext(JsProgram program, DartMangler mangler) {
    this.program = program;
    this.mangler = mangler;
    this.names = new JsNameProvider(program, mangler);
  }

  public DartMangler getMangler() {
    return mangler;
  }

  public Map<Element, JsScope> getMemberScopes() {
    return memberScopes;
  }

  public Map<DartFunction, JsFunction> getMethods() {
    return methods;
  }

  public JsNameProvider getNames() {
    return names;
  }

  public JsProgram getProgram() {
    return program;
  }

  /**
   *
   * @param unit  Unit to create translation context for
   * @param program
   * @param mangler
   * @param filterNode If not null, create names for this node only.
   * @return
   */
  public static TranslationContext createContext(DartUnit unit, JsProgram program,
                                                 DartMangler mangler, DartNode filterNode) {
    TranslationContext translationContext = new TranslationContext(program, mangler);
    LibraryElement unitLibrary = unit.getLibrary().getElement();
    GenerateNamesAndScopes visitor = new GenerateNamesAndScopes(translationContext, unitLibrary);
    if (filterNode != null) {
      visitor.accept(filterNode);
    } else {
      visitor.accept(unit);
    }
    return translationContext;
  }


}