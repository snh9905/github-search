import 'dart:async';

import 'package:angular/core.dart';
import 'package:github_user_search/models/commit.dart';
import 'package:github_user_search/models/repo.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

@Injectable()
class RepoService {
  
  BrowserClient client = new BrowserClient();

  Future<Map<String, dynamic>> getReposForUser(String username, [String pageUrl = ""]) async {

    List<Repo> repos = new List<Repo>();
    Map<String, dynamic> results = new Map<String, dynamic>();

    Response response;
    String url;

    // if we are paging, use the passed in url. otherwise, use the regular one
    if (pageUrl != "") {
      url = pageUrl;
    } else {
      url = "https://api.github.com/users/" + username + "/repos?sort=updated&order=desc";
    }

    try {
      response = await client.get(url);

      if (response.statusCode == 404) {
        results = null;
      } else {
        // grab paging info from headers
        results = addPagingToResults(results, response.headers);
        // grab the list
        repos = new Repo().getListFromJson(response.body);
        // add list to results
        results.putIfAbsent('results', () => repos);
      }
    
    } catch (exception, stacktrace) {
      results = null; // catch all
      print(exception + " : " + stacktrace);
    }
    
    return results;
  }

  Future<Map<String, dynamic>> getCommitsByRepo(String name, String username, [String pageUrl = ""]) async {

    List<Commit> commits = new List<Commit>();
    Map<String, dynamic> results = new Map<String, dynamic>();

    Response response;
    String url;

    // if we are paging, use the passed in url. otherwise, use the regular one
    if (pageUrl != "") {
      url = pageUrl;
    } else {
      url = "https://api.github.com/repos/" + username + "/" + name + "/commits";
    }

    try {
      response = await client.get(url);

      if (response.statusCode == 404 || response.statusCode == 409) {
        results = null;
      } else {
        // grab paging info from headers
        results = addPagingToResults(results, response.headers);
        // grab the list
        commits = new Commit().getListFromJson(response.body);
        // add list to results
        results.putIfAbsent('results', () => commits);
      }
    
    } catch (exception, stacktrace) {
      results = null; // catch all
      print(exception + " : " + stacktrace);
    }
    
    // return repos;
    return results;
  }

  Map<String, dynamic> addPagingToResults(Map<String, dynamic> results, [Map<String, String> linkHeaders]) {

    String linkHeaderString = linkHeaders["link"];

    if (linkHeaderString != null) {
      List<String> pagingArr = linkHeaderString.split(",");

      for (int i = 0; i < pagingArr.length; i++) {
        String url = pagingArr[i].split(";")[0].replaceAll(new RegExp("(<|>| )"), "");
        String type = pagingArr[i].split('"')[1].trim();
        results.putIfAbsent(type, () => url);
      }
    } 
    return results;
  }

}