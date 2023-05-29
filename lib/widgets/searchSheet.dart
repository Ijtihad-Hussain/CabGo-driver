import 'package:flutter/material.dart';
import '../utils/constants.dart';


class SearchSheet extends StatelessWidget {
  final double? height;
  final VoidCallback? ontap;
  final String? text;

  SearchSheet({Key? key, this.height, this.ontap, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      // vsync: this,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeIn,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: kDBlack,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 12,
              spreadRadius: 0.5,
              offset: Offset(
                0.7,
                0.7,
              ),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: ontap,
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 12,
                          spreadRadius: 0.5,
                          offset: Offset(
                            0.7,
                            0.7,
                          ),
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          text!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/cab.png',
                  height: 70,
                  width: 70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
