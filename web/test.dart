import 'dart:html';
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2/di.dart';
import 'package:angular2/src/render/dom/shadow_dom/shadow_dom_strategy.dart';
import 'package:angular2/src/render/dom/shadow_dom/native_shadow_dom_strategy.dart';
import 'package:angular2/src/reflection/reflection.dart';
import 'package:angular2/src/reflection/reflection_capabilities.dart';

amain() {
  // For now, use dynamic reflection (mirrors).
  // https://github.com/angular/angular/issues/1063
  reflector.reflectionCapabilities = new ReflectionCapabilities();
  final testBindings = [
    bind(ShadowDomStrategy).toClass(NativeShadowDomStrategy)
  ];
  testBindings.addAll(routerInjectables);

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
@View(
  directives: const [RouterLink, RouterOutlet],
  template: """<router-outlet name="default"></router-outlet>
  <a router-link="error" href="#" target rel="noreferrer">Error for me</a>""")
@RouteConfig(const [
  const {
    'path': '/error',
    'component': DefaultView,
    'as': 'error'
  }])
class MyComp {
}

@Component(selector: 'why-do-i-need-this')
class DefaultView {
  DefaultView() {
    print('DefaultView created. I will now throw an exception');
    throw 'Do you see it now?';
  }
}
