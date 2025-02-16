import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViajesScreen2 extends StatelessWidget {
  const ViajesScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget locationSvg = SvgPicture.asset(
      "assets/location.svg",
      semanticsLabel: 'Location',
    );

    final Widget arrowDownSvg = SvgPicture.asset(
      "assets/arrow_down.svg",
      semanticsLabel: 'Arrow Down',
    );
    final Widget searchSvg = SvgPicture.asset(
      "assets/search.svg",
      semanticsLabel: 'Search',
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: 20,
          top: 44,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Explore",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: locationSvg,
                      ),
                      Text(
                        'Aspen, USA',
                        style: TextStyle(
                          color: Color(0xFF5F5F5F),
                          fontSize: 12,
                          fontFamily: 'CircularXX',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: arrowDownSvg,
                      )
                    ],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Aspen',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            //=== Sección de barra de busqueda ===
            Padding(
              padding: EdgeInsets.only(
                top: 24,
                bottom: 32,
                right: 20,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 52,
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  bottom: 16,
                ),
                decoration: ShapeDecoration(
                  color: Color(0xFFF3F8FE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: 8,
                      ),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Color.fromARGB(66, 0, 0, 0),
                          BlendMode.srcIn,
                        ),
                        child: searchSvg,
                      ),
                    ),
                    Text(
                      'Find things to do',
                      style: TextStyle(
                        color: Color.fromARGB(66, 0, 0, 0),
                        fontSize: 12,
                        fontFamily: 'CircularXX',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //=== Sección de botones de categorias ===
            Padding(
              padding: EdgeInsets.only(
                bottom: 32,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 41,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color(0xFFF3F8FE),
                        ),
                        shadowColor: WidgetStateProperty.all(
                          Color.fromARGB(0, 243, 248, 254),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                        ),
                        child: Text(
                          'Location',
                          style: TextStyle(
                            color: Color(0xFF176EF2),
                            fontSize: 12,
                            fontFamily: 'CircularXX',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12), // Espacio entre botones
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(0, 243, 248, 254),
                        ),
                        shadowColor: WidgetStateProperty.all(
                          Color.fromARGB(0, 243, 248, 254),
                        ),
                      ),
                      child: Text(
                        'Hotels',
                        style: TextStyle(
                          color: Color.fromARGB(64, 0, 0, 0),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(width: 12), // Espacio entre botones
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(0, 243, 248, 254),
                        ),
                        shadowColor: WidgetStateProperty.all(
                          Color.fromARGB(0, 243, 248, 254),
                        ),
                      ),
                      child: Text(
                        'Food',
                        style: TextStyle(
                          color: Color.fromARGB(64, 0, 0, 0),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(width: 12), // Espacio entre botones
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(0, 243, 248, 254),
                        ),
                        shadowColor: WidgetStateProperty.all(
                          Color.fromARGB(0, 243, 248, 254),
                        ),
                      ),
                      child: Text(
                        'Adventure',
                        style: TextStyle(
                          color: Color.fromARGB(64, 0, 0, 0),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // === Sección de populares ===
            Column(children: [
              Row(
                children: [
                  Text(
                    'Popular ',
                    style: TextStyle(
                      color: Color(0xFF232323),
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 271,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12,bottom: 19),
                      height: 222,
                      width: 188,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 59, 90, 129),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 28,
                    ),
                    SizedBox(
                      height: 271,
                      width: 212,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 59, 90, 129),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
