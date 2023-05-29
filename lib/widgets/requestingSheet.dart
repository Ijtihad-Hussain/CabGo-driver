import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class RequestingSheet extends StatelessWidget {
  final double? height;
  final Widget? text;
  final Widget? icon;


  const RequestingSheet({Key? key, this.height, this.text, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 150),
      // vsync: this,
      curve: Curves.easeIn,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: kLBlack,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            ),
          ],
        ),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextLiquidFill(
                    text: 'Requesting a Ride...',
                    waveColor: Colors.blueAccent,
                    boxBackgroundColor: kYellow,
                    textStyle: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                    boxHeight: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: 100,
                        child: text,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            width: 1, color: Colors.blueGrey),
                      ),
                      child: icon,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
