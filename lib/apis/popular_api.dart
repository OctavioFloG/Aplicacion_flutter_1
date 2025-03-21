import 'package:dio/dio.dart';
import 'package:flutter_application_1/models/popular_model.dart';

class PopularApi {
  final dio = Dio();
  
  Future<List<PopularModel>?> getHttpPopular() async{
    final response = await dio.get("https://api.themoviedb.org/3/movie/popular?api_key=52ade9e9b5b7943a92878efe17b57217&language=es-MX&page=1");
    if(response.statusCode == 200){
      final res = response.data['results'] as List;
      return res.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }
}
