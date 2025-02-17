import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemRecommendedHotels extends StatelessWidget {
  const ItemRecommendedHotels({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget hotSealSvg = SvgPicture.asset(
      "assets/hot-seal.svg",
      semanticsLabel: 'Hot Seal',
    );
    return Container(
      width: 205,
      height: 152,
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.91, -0.42),
          end: Alignment(-0.91, 0.42),
          colors: [Colors.white, Color(0xFFF5F5F5)],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFF4F4F4)),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x2B979FB2),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 196,
            height: 102,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 196,
                    height: 96,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/hotel1.png"),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 136,
                  top: 86,
                  child: Container(
                    width: 41,
                    height: 16,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: ShapeDecoration(
                      color: Color(0xFF3A544F),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '4N/5D',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Aspen',
                        style: TextStyle(
                          color: Color(0xFF232323),
                          fontSize: 14,
                          fontFamily: 'CircularXX',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.only(left: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: hotSealSvg,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Hot Deal',
                        style: TextStyle(
                          color: Color(0xFF3A544F),
                          fontSize: 10,
                          fontFamily: 'CircularXX',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
