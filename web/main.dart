import 'package:angular/angular.dart';

import 'package:angular_router/angular_router.dart';
import 'package:github_user_search/app_component.dart';

void main() {
  bootstrap(AppComponent, [
    ROUTER_PROVIDERS,
    // TODO: Remove next line in production
    provide(LocationStrategy, useClass: HashLocationStrategy),
  ]);
  
}