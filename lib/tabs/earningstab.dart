
import 'package:cab_go_driver/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/brandDivider.dart';
import '../utils/providerAppData.dart';


class EarningsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          color: kLBlack,
          width: double.infinity,
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [

                // Text('Total Earnings', style: TextStyle(color: Colors.white),),
                // Text('\$${Provider.of<AppData>(context).earnings}', style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: 'Brand-Bold'),)
              ],
            ),
          ),
        ),

        TextButton(
          // padding: EdgeInsets.all(0),
          onPressed: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> HistoryPage()));
          },

          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: [
                Image.asset('images/taxi.png', width: 70,),
                SizedBox(width: 16,),
                Text('Trips', style: TextStyle(fontSize: 16), ),
                // Expanded(child: Container(child: Text(Provider.of<AppData>(context).tripCount.toString(), textAlign: TextAlign.end, style: TextStyle(fontSize: 18),))),
              ],
            ),
          ),

        ),

        BrandDivider(),

      ],
    );
  }
}
