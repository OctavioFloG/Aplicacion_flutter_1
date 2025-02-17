import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/view/item_category_button.dart';
import 'package:flutter_application_1/view/item_popular_hotels.dart';
import 'package:flutter_application_1/view/item_recommended_hotels.dart';
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
    final Widget profileSvg = SvgPicture.asset(
      "assets/profile.svg",
      semanticsLabel: 'Profile',
    );
    final Widget outlineHeartSvg = SvgPicture.asset(
      "assets/outline-heart.svg",
      semanticsLabel: 'Heart',
    );
    final Widget ticketSvg = SvgPicture.asset(
      "assets/ticket.svg",
      semanticsLabel: 'Ticket',
    );
    final Widget curvedHomeSvg = SvgPicture.asset(
      "assets/curved-home.svg",
      semanticsLabel: 'Home',
    );

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
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
                              "Aspen, USA",
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
                      "Aspen",
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
                      padding: const EdgeInsets.only(
                        left: 16,
                      ),
                      decoration: ShapeDecoration(
                        color: Color(0xFFF3F8FE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: Color.fromARGB(66, 0, 0, 0),
                            fontSize: 12,
                            fontFamily: 'CircularXX',
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: "Find things to do",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(66, 0, 0, 0),
                            fontSize: 12,
                            fontFamily: 'CircularXX',
                            fontWeight: FontWeight.w400,
                          ),
                          icon: searchSvg,
                        ),
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
                          ItemCategoryButton(),
                          SizedBox(width: 12), // Espacio entre botones
                          ItemCategoryButton(),
                          SizedBox(width: 12), // Espacio entre botones
                          ItemCategoryButton(),
                          SizedBox(width: 12), // Espacio entre botones
                          ItemCategoryButton()
                        ],
                      ),
                    ),
                  ),
                  // === Sección de populares ===
                  Column(children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Popular",
                            style: TextStyle(
                              color: Color(0xFF232323),
                              fontSize: 18,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "See all",
                            style: TextStyle(
                              color: Color(0xFF176EF2),
                              fontSize: 14,
                              fontFamily: 'CircularXX',
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 12, bottom: 19),
                            child: SizedBox(
                                width: 188,
                                height: 240,
                                child: ItemPopularHotels()),
                          ),
                          SizedBox(width: 28),
                          SizedBox(
                              height: 271,
                              width: 212,
                              child: ItemPopularHotels()),
                          SizedBox(width: 20)
                        ],
                      ),
                    ),
                  ]),
                  Column(children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Recommended",
                          style: TextStyle(
                            color: Color(0xFF232323),
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 380,
                      child:
                          ListView(scrollDirection: Axis.horizontal, children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                ItemRecommendedHotels(),
                                SizedBox(
                                  width: 20,
                                ),
                                ItemRecommendedHotels(),
                                SizedBox(
                                  width: 20,
                                ),
                                ItemRecommendedHotels()
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                ItemRecommendedHotels(),
                                SizedBox(
                                  width: 20,
                                ),
                                ItemRecommendedHotels(),
                                SizedBox(
                                  width: 20,
                                ),
                                ItemRecommendedHotels()
                              ],
                            )
                          ],
                        ),
                      ]),
                    ),
                  ])
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  selectedItemColor: Color(0xFF176EF2),
                  unselectedItemColor: Colors.grey,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: curvedHomeSvg,
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: ticketSvg,
                      label: 'Ticket',
                    ),
                    BottomNavigationBarItem(
                      icon: outlineHeartSvg,
                      label: 'Favorites',
                    ),
                    BottomNavigationBarItem(
                      icon: profileSvg,
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
