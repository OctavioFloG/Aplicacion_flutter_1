import 'package:flutter/material.dart';
import 'package:flutter_application_1/apis/popular_api.dart';
import 'package:flutter_application_1/models/popular_model.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreen();
}

class _PopularScreen extends State<PopularScreen> {

  PopularApi? popular;
  @override
  void initState() {
    super.initState();
    popular = PopularApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular movies'),),
      body: FutureBuilder(
        future: popular!.getHttpPopular(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
              ),
              itemBuilder: (context, index) {
                return ItemPopular(snapshot.data![index]);
              },
            );
          }else{
            if( snapshot.hasError){
              return Center(child: Text('Ocurrio un errror'),);
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
        },
      ),
    );
  }

  Widget ItemPopular(PopularModel popular){
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: popular);
      },
      child: Container(
      height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Hero(
            tag: "https://image.tmdb.org/t/p/w500${popular.posterPath}",
            child: FadeInImage(
              fadeInDuration: Duration(seconds: 3),
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/lding.gif'),
              image: NetworkImage('https://image.tmdb.org/t/p/w500${popular.posterPath}')
            ),
          ),
        ),
      ),
    );
  }
}