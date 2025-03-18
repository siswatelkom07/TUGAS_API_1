import 'package:flutter_application_1/services/url.dart' as url;

class MovieModel {
  int? id;
  String? title;
  double? voteAverage;
  String? overview;
  String? posterPath;
  int? categoryId;

  MovieModel({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.overview,
    required this.posterPath,
    required this.categoryId,
  });

  MovieModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    title = parsedJson['title'];
    voteAverage = double.parse(parsedJson['voteaverage'].toString());
    overview = parsedJson['overview'];
    posterPath = "${url.BaseUrl}/${parsedJson["posterpath"]}";
    categoryId = parsedJson['category_id'];
  }
}