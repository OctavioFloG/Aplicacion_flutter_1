import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/item_facilities.dart';
import 'package:flutter_svg/svg.dart';

class ViajesScreen3 extends StatelessWidget {
  const ViajesScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget heartIconSvg = SvgPicture.asset(
      "assets/heart-icon.svg",
      semanticsLabel: 'Heart Icon',
    );
    final Widget starSvg = SvgPicture.asset(
      "assets/star.svg",
      semanticsLabel: 'Star',
    );
    final Widget arrowDownSvg = SvgPicture.asset(
      "assets/arrow_down.svg",
      semanticsLabel: 'Arrow Down',
    );
    final Widget arrowRightSvg = SvgPicture.asset(
      "assets/arrow_right.svg",
      semanticsLabel: 'Arrow Right',
    );
    final Widget backSvg = SvgPicture.asset(
      "assets/back.svg",
      semanticsLabel: 'Back',
    );

    return Scaffold(
      appBar: AppBar(),
      // === Barra de navegación de abajo ===
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Price',
                    style: TextStyle(
                      color: Color(0xFF232323),
                      fontSize: 12,
                      fontFamily: 'CircularXX',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$199',
                    style: TextStyle(
                      color: Color(0xFF2CD6A3),
                      fontSize: 24,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              Container(
                width: 223,
                height: 56,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.00, 0.01),
                    end: Alignment(1, -0.01),
                    colors: [Color(0xFF176EF2), Color(0xFF186EEE)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3D0038FF),
                      blurRadius: 19,
                      offset: Offset(0, 6),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Book Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'CircularXX',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: arrowRightSvg,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // === Cuerpo Principal ===
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 386,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 360,
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            image: DecorationImage(
                                image: AssetImage("assets/hotel2.png"),
                                fit: BoxFit.fitWidth)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 40,
                          height: 40,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Color(0xFFF3F8FE),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: backSvg,
                        ),
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: ShapeDecoration(
                        color: Color(0xFFF2F7FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x190038FF),
                            blurRadius: 19,
                            offset: Offset(0, 6),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: heartIconSvg,
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Coeurdes Alpes',
                    style: TextStyle(
                      color: Color(0xFF232323),
                      fontSize: 24,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Show map',
                    style: TextStyle(
                      color: Color(0xFF176EF2),
                      fontSize: 14,
                      fontFamily: 'CircularXX',
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  starSvg,
                  Text(
                    '4.5 (355 Reviews)',
                    style: TextStyle(
                      color: Color(0xFF5F5F5F),
                      fontSize: 12,
                      fontFamily: 'CircularXX',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 17,
              ),
              Text(
                "Aspen is as close as one can get to a storybook alpine town in America. The choose-your-own-adventure possibilities—skiing, hiking, dining shopping and ....",
                style: TextStyle(
                  color: Color(0xFF3A544F),
                  fontSize: 14,
                  fontFamily: 'CircularXX',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 9,
              ),
              Row(
                children: [
                  Text(
                    "Read more",
                    style: TextStyle(
                      color: Color(0xFF176EF2),
                      fontSize: 14,
                      fontFamily: 'CircularXX',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: arrowDownSvg,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              SizedBox(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Facilities',
                        style: TextStyle(
                          color: Color(0xFF232323),
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ItemFacilities(),
                        ItemFacilities(),
                        ItemFacilities(),
                        ItemFacilities(),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
