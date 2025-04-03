import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/popular_model.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DetailPopularScreen extends StatefulWidget {
  DetailPopularScreen({super.key, this.popularModel});

  PopularModel? popularModel;

  @override
  State<DetailPopularScreen> createState() => _DetailPopularScreenState();
}

class _DetailPopularScreenState extends State<DetailPopularScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
        videoId: "xvFZjo5PgG0", autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)!.settings.arguments as PopularModel;
    final space = SizedBox(height: 10);
    return Scaffold(
      // appBar: AppBar(title: Text(widget.popularModel!.title),),
      appBar: AppBar(
        title: Text(popular.title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.white,
              Colors.blue,
            ]
                )),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 230,
              child: YoutubePlayer(
                controller: _controller!,
                aspectRatio: 16 / 9,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 250,
              child: Row(
                spacing: 10,
                children: [
                  Hero(
                    tag: "https://image.tmdb.org/t/p/w500${popular.posterPath}",
                    child: Image.network(
                        "https://image.tmdb.org/t/p/w500${popular.posterPath}"),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * .55,
                      child: Text(
                        popular.overview,
                        textAlign: TextAlign.justify,
                      ))
                ],
              ),
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
              child: Column(children: [
                StarRating(rating: popular.voteAverage / 2),
                Text((popular.voteAverage / 2).toString())
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
