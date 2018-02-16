import 'dart:async';

import 'package:angular/core.dart';
import 'package:github_user_search/models/commit.dart';
import 'package:github_user_search/models/repo.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

@Injectable()
class RepoService {
  List<Repo> repos = <Repo>[];
  List<Commit> commits = <Commit>[];

  BrowserClient client = new BrowserClient();

  Future<List<Repo>> getReposForUser(String username) async {

    Response response;
    String url = "https://api.github.com/users/" + username + "/repos?sort=updated&order=desc";

    try {
      response = await client.get(url);

      if (response.statusCode == 404) {
        // not found. return null
        repos = null;
      } else {
        repos = new Repo().getListFromJson(response.body);
      }
    
    } catch (exception, stacktrace) {
      repos = null; // catch all
      print(exception + " : " + stacktrace);
    }
    
    return repos;
  }

  Future<List<Commit>> getCommitsByRepo(String name, String username) async {

    Response response;
    String url = "https://api.github.com/repos/" + username + "/" + name + "/commits";

    try {
      response = await client.get(url);

      if (response.statusCode == 404 || response.statusCode == 409) {
        // not found. return null
        commits = null;
      } else {
        commits = new Commit().getListFromJson(response.body);
      }
    
    } catch (exception, stacktrace) {
      commits = null; // catch all
      print(exception + " : " + stacktrace);
    }
    
    // return repos;
    return commits;
  }

}