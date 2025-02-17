import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemPopularHotels extends StatelessWidget {
  const ItemPopularHotels({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget starSvg = SvgPicture.asset(
      "assets/star.svg",
      semanticsLabel: 'Star',
    );

    final Widget heartIconSvg = SvgPicture.asset(
      "assets/heart-icon.svg",
      semanticsLabel: 'Heart Icon',
    );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/viajes3"),
      child: Container(
        margin: EdgeInsets.only(top: 12, bottom: 19),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/hotel1.png"),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 12, bottom: 12),
          child: Column(
            spacing: 2,
            verticalDirection: VerticalDirection.up,
            children: [
              // === Estrellas del hotel ===
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(254, 86, 82, 77),
                        borderRadius: BorderRadius.circular(59),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 4, bottom: 4, left: 12, right: 12),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          starSvg,
                          Text(
                            "4.1",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'CircularXX',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: heartIconSvg,
                    ),
                  ),
                )
              ]),
              //=== Nombre del hotel ===
              Align(
                alignment: Alignment.bottomLeft,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(254, 86, 82, 77),
                    borderRadius: BorderRadius.circular(59),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 4, bottom: 4, left: 12, right: 12),
                    child: Text(
                      "Alley Palace",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'CircularXX',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
