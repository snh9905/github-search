import 'dart:convert';

class Repo {

  int id;
  String name;
  int stars;
  DateTime updated;
  String updatedString;

  Repo fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    stars = data['stargazers_count']; 
    if (data.containsKey('updated_at')) {
      updated = DateTime.parse(data['updated_at']).toLocal();
      getUpdatedString();
    }
    return this;
  }

  List<Repo> getListFromJson(String jsonString) {
    return JSON.decode(jsonString)
        .map((value) => new Repo().fromJson(value))
        .toList();
  }

  void getUpdatedString() {
    Duration difference = new DateTime.now().toLocal().difference(updated);
    int diff = difference.inDays;

    if (diff < 1) {
      updatedString = "Updated today";

    } else if (diff > 0 && diff < 7) {
      updatedString = diff.toString() + " day" + (diff > 1 ? "s" : "") + " ago";

    } else if (diff > 6 && diff < 30) {
      int weeks = (diff/7).round().toInt();
      updatedString = weeks.toString() + " week" + (weeks > 1 ? "s" : "") + " ago";

    } else if (diff > 29 && diff < 365) {
      int months = (diff/30).round().toInt();
      updatedString = months.toString() + " month" + (months > 1 ? "s" : "") + " ago";

    } else if (diff > 364) {
      int years = (diff/365).round().toInt();
      updatedString = years.toString() + " year" + (years > 1 ? "s" : "") + " ago";

    }
  }

}