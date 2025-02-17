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

    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Column(
          children: [],
        ),
      ),
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
