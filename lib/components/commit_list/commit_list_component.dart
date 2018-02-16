import 'dart:async';

import 'dart:html' show window; 
import 'dart:math';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:github_user_search/models/commit.dart';
import 'package:github_user_search/services/repo_service.dart';
import '../../globals.dart' as globals;

@Component(
  selector: 'commit-list',
  styleUrls: const ['commit_list_component.css'],
  templateUrl: 'commit_list_component.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
    formDirectives
  ],
  providers: const [RepoService]
)
class CommitListComponent implements OnInit {
  final RepoService _repoService;
  final RouteParams _routeParams;
  final Location _location;

  List<Commit> commits;
  String repoName;
  String username;
  String message;
  bool showSpinner = false;

  Map<String, dynamic> results;

  CommitListComponent(this._repoService, this._routeParams, this._location);

  @override
  Future<Null> ngOnInit() async {

    repoName = _routeParams.get('name');
    username = _routeParams.get('username');

    if (repoName != null && username != null) {
      getCommits();
    }
    
  }

  Future<Null> getCommits([String pageUrl = ""]) async { 
    showSpinner = true;
    message = null;

    try {
      globals.username = username;
      results = await (_repoService.getCommitsByRepo(repoName, username, pageUrl));

      showSpinner = false;
      
      if (results == null) {
        message = "There are no commits to display.";
      } else {
        message = null;
        commits = results["results"];
      }

    } catch (exception, stacktrace) {
      print(exception + " : " + stacktrace); 
    }

  }

  void openCommit(Commit commit) {
    int rnum = new Random().nextInt(1000);
    window.open(commit.url, 'github' + rnum.toString());
  }

  void goBack() => _location.back();

}