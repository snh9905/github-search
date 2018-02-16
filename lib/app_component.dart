import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:github_user_search/components/commit_list/commit_list_component.dart';
import 'package:github_user_search/components/repo_list/repo_list_component.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [
    materialDirectives, 
    ROUTER_DIRECTIVES
  ],
  providers: const [],
)

@RouteConfig(const [
  const Route(
      path: '/',
      name: 'RepoList',
      useAsDefault: true,
      component: RepoListComponent),
  const Route(
      path: '/commits/:username/:name',
      name: 'CommitList',
      component: CommitListComponent),
  
])

class AppComponent {

}
