class PopularModel {
  String backdropPath;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  String title;
  double voteAverage;
  int voteCount;

  PopularModel({
    required this.backdropPath,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  factory PopularModel.fromMap(Map<String, dynamic> popular) {
    return PopularModel(
        backdropPath: popular['backdropPath']??"hola",
        id: popular['id']??0,
        originalLanguage: popular['originalLanguage']??"",
        originalTitle: popular['originalTitle']??"",
        overview: popular['overview']??"",
        popularity: popular['popularity']??0,
        posterPath: popular['posterPath']??"",
        releaseDate: popular['releaseDate']??"",
        title: popular['title']??"",
        voteAverage: popular['voteAverage']??0  ,
        voteCount: popular['voteCount']??0);
  }
}
