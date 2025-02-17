import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemFacilities extends StatelessWidget {
  const ItemFacilities({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget wifiSvg = SvgPicture.asset(
      "assets/wifi.svg",
      semanticsLabel: 'Wifi',
    );
    return Container(
      width: 77,
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1.00, 0.01),
          end: Alignment(1, -0.01),
          colors: [
            Color.fromARGB(5, 23, 111, 242),
            Color.fromARGB(5, 25, 110, 238)
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: wifiSvg,
          ),
          const SizedBox(height: 6),
          Text(
            '1 Heater',
            style: TextStyle(
              color: Color(0xFFB7B7B7),
              fontSize: 8,
              fontFamily: 'CircularXX',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
