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
    return Scaffold(
      // appBar: AppBar(title: Text(widget.popularModel!.title),),
      appBar: AppBar(
        title: Text(popular.title),
      ),
    );
  }
}