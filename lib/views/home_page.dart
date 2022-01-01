import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/views/widgets/clock.dart';
import 'package:flutter_alarm_app/views/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("   Alarm", style: TextStyle(
          color: Colors.black
        )),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,

      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 80.w,
                child: ClockWidget()
              ),
              SizedBox(height: 10.w,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NormalText(
                    text: "Alarm Active: 2", 
                    color: Colors.black, 
                    size: 13.sp
                  ),
                  Container(
                    width: 2,
                    height: 10.w,
                    color: Colors.grey,
                  ),
                  NormalText(
                    text: "Alarm inactive: 4", 
                    color: Colors.black, 
                    size: 13.sp
                  )
                ],
              ),
              SizedBox(height: 10.w,),

            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
