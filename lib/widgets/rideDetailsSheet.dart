import 'package:flutter/material.dart';

import '../utils/constants.dart';

class RideDetailsSheet extends StatefulWidget {
  final double? height;
  final VoidCallback? ontap;
  final String? text;
  final Widget? sendRequestWidget;
  final TextField? textField;

  RideDetailsSheet({Key? key, this.height, this.ontap, this.text, this.textField,this.sendRequestWidget})
      : super(key: key);

  @override
  State<RideDetailsSheet> createState() => _RideDetailsSheetState();
}

class _RideDetailsSheetState extends State<RideDetailsSheet> {

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      // vsync: this,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeIn,
      child: Container(
        decoration: const BoxDecoration(
          color: kLBlack,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            ),
          ],
        ),
        height: widget.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: kDBlack,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/cab.png',
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          children: const [
                            Text(
                              'Cab',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            // Text((tripDirectionDetails != null) ? '\$${HelperMethods.estimateFares(tripDirectionDetails!)}' : '', style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Expanded(child: Container()),
                        Text(
                          widget.text!,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: widget.textField!,
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(kYellow),
                      ),
                      onPressed: widget.ontap,
                      child: widget.sendRequestWidget!,
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
