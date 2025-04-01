import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/popular_model.dart';

class DetailPopularScreen extends StatefulWidget {
  DetailPopularScreen({super.key, this.popularModel});

  PopularModel? popularModel;

  @override
  State<DetailPopularScreen> createState() => _DetailPopularScreenState();
}

class _DetailPopularScreenState extends State<DetailPopularScreen> {
  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)!.settings.arguments as PopularModel;
    final space = SizedBox(height: 10);
    return Scaffold(
      // appBar: AppBar(title: Text(widget.popularModel!.title),),
      appBar: AppBar(
        title: Text(popular.title),
      ),
      body: Hero(
        tag: "https://image.tmdb.org/t/p/w500${popular.posterPath}",
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  opacity: .5,
                  image: NetworkImage(
                      "https://image.tmdb.org/t/p/w500${popular.posterPath}"))),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 250,
                color: Colors.red,
              ),
              space,
              Container(
                height: 200,
                color: Colors.white,
                child: Text(popular.overview),
              ),
              space,
              Container(
                height: 100,
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
