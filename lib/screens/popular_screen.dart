import 'package:flutter/material.dart';
import 'package:flutter_application_1/apis/popular_api.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  PopularApi? popular;
  @override
  void initState() {
    super.initState();
    popular = PopularApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Popular Movies"),
      ),
      body: FutureBuilder(
          future: popular!.getHttpPopular(), builder: (context, snapshot) {
            if(snapshot.hasData){
              return GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
                itemBuilder: (context,index){
                  return ListTile();
                });
            }else{
              if(snapshot.hasError){

              }else{
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
