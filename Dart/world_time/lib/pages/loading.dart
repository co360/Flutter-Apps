import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setupWorldTime() async {
    // creating an instance
    WorldTime instance = WorldTime(
        location: 'Nairobi', flag: 'kenya.png', url: 'Africa/Nairobi');
    await instance.getTime();
    // Navigator helps navigate/switch to new screen/page
    // pushReplacementNamed avoids adding routes as a stack
    // arguments (optional) allows us to pass data to the new screen/page
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDaytime': instance.isDaytime
    });
  }

  @override
  // override the original initState from State<ChooseLocation> class
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        // spinner
        child: SpinKitCircle(
            color: Colors.white,
            size: 80.0,
          ),
      ),
    );
  }
}
