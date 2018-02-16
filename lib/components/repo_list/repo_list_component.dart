import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:github_user_search/models/repo.dart';
import 'package:github_user_search/services/repo_service.dart';
import '../../globals.dart' as globals;

@Component(
  selector: 'repo-list',
  styleUrls: const ['repo_list_component.css'],
  templateUrl: 'repo_list_component.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
    formDirectives, 
    ROUTER_PROVIDERS
  ],
  providers: const [RepoService],
)
class RepoListComponent implements OnInit {
  final RepoService _repoService;
  final Router _router;

  List<Repo> repos = globals.repos;
  String username = globals.username;
  String message;
  bool showSpinner = false;

  RepoListComponent(this._router, this._repoService);

  @override
  Future<Null> ngOnInit() async {
    
    // if we used the back button, fill the list back in
    // needs more testing to determine which navigation scenarios will result in empty data
    if (globals.repos != null) {
      repos = globals.repos;
    } else {
      message = "Search for a Github username to get started.";
    }
  
  }

  Future<Null> getRepos() async { 
    showSpinner = true;
    message = null;

    repos = await _repoService.getReposForUser(username);
    globals.repos = null;
    globals.username = username;

    showSpinner = false;

    if (repos == null) {
      message = "No user found with the username, " + username + ".";

    } else if (repos.length < 1) {
      message = "No public repositories found for the user " + username + "."; 

    } else {
      message = null;
      globals.repos = repos;
    }
  }

  void showDetails(Repo repo) {
    _router.navigate([ 'CommitList', {'username': username, 'name': repo.name} ]);
  }

}