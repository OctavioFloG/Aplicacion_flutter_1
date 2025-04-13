import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
          backgroundColor: Colors.orange[100],
          title: Center(
            child: Text(
              'Hola Mundo :)',
              style: TextStyle(
                  fontFamily: "ShadeBlue",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600]),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Image.network("https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.tecnm.mx%2F%3Fvista%3DTecNM_Virtual%26tecnm_virtual%3DBibliotecas&psig=AOvVaw1SLJfhAIx3xIjSiaecZ2Ct&ust=1738881053849000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCODxz-7KrYsDFQAAAAAdAAAAABAJ"),
            //child: Icon(Icons.ads_click),
            onPressed: () {
              contador++;
              print(contador);
              setState(() {});
            }),
        body: Center(
          child: Text(
            'Valor del contador $contador',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
