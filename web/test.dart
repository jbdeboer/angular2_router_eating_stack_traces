import 'dart:html';
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/di.dart';
import 'package:angular2/src/render/dom/shadow_dom/shadow_dom_strategy.dart';
import 'package:angular2/src/render/dom/shadow_dom/native_shadow_dom_strategy.dart';
import 'package:angular2/src/reflection/reflection.dart';
import 'package:angular2/src/reflection/reflection_capabilities.dart';

origin() {
  throw 'An exception. Can you see origin() in the stack?';
}

amain() {
  print('This program will trigger a stack trace. The function origin() \n'
    'should be included in the stack trace.');

  // For now, use dynamic reflection (mirrors).
  // https://github.com/angular/angular/issues/1063
  reflector.reflectionCapabilities = new ReflectionCapabilities();
  final testBindings = [
    bind(ShadowDomStrategy).toClass(NativeShadowDomStrategy)
  ];

  bootstrap(MyComp, testBindings);
}

main() {
  Zone.current.fork(specification:
      new ZoneSpecification(handleUncaughtError: (self, parent, zone,
          error, stack) {
    print('Caught an error: Error:[$error] Stack:[$stack]');
  })).run(amain);
}

@Component(selector: 'my-comp')
class MyComp {
  MyComp() {
    print('Calling origin');
    origin();
    print('Done origin');
  }
}
