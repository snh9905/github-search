import 'dart:convert';

class Commit {

  CommitDetail commitDetail;
  String url;

  Commit fromJson(Map<String, dynamic> data) {
    // message = data['commit'].message;
    commitDetail = new CommitDetail().fromJson(data['commit']);
    url = data['html_url'];
    
    return this;
  }

  List<Commit> getListFromJson(String jsonString) {
    return JSON.decode(jsonString)
        .map((value) => new Commit().fromJson(value))
        .toList();
  }

}

class CommitDetail {

  String message;

  CommitDetail fromJson(Map<String, dynamic> data) {
    message = data['message'];
    
    return this;
  }

}