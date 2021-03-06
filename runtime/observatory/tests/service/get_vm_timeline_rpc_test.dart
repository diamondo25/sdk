// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// VMOptions=--error_on_bad_type --error_on_bad_override --complete_timeline

import 'dart:developer';
import 'package:observatory/service_io.dart';
import 'package:unittest/unittest.dart';

import 'test_helper.dart';

primeTimeline() {
  Timeline.startSync('apple');
  Timeline.instantSync('ISYNC');
  Timeline.finishSync();
  TimelineTask task = new TimelineTask();
  task.start('TASK1');
  task.instant('ITASK');
  task.finish();
}

List<Map> filterForDartEvents(List<Map> events) {
  return events.where((event) => event['cat'] == 'Dart').toList();
}

bool eventsContains(List<Map> events, String phase, String name) {
  for (Map event in events) {
    if ((event['ph'] == phase) && (event['name'] == name)) {
      return true;
    }
  }
  return false;
}

var tests = [
  (VM vm) async {
    Map result = await vm.invokeRpcNoUpgrade('_getVMTimeline', {});
    expect(result['type'], equals('_Timeline'));
    expect(result['traceEvents'], new isInstanceOf<List>());
    List<Map> dartEvents = filterForDartEvents(result['traceEvents']);
    expect(dartEvents.length, equals(5));
    expect(eventsContains(dartEvents, 'I', 'ISYNC'), isTrue);
    expect(eventsContains(dartEvents, 'X', 'apple'), isTrue);
    expect(eventsContains(dartEvents, 'b', 'TASK1'), isTrue);
    expect(eventsContains(dartEvents, 'e', 'TASK1'), isTrue);
    expect(eventsContains(dartEvents, 'n', 'ITASK'), isTrue);
    expect(eventsContains(dartEvents, 'q', 'ITASK'), isFalse);
  },
];

main(args) async => runVMTests(args, tests, testeeBefore: primeTimeline);
