import 'package:WebSiteAppMaker/colors_code.dart';
import 'package:flutter/material.dart';


class Progress extends StatefulWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  ProgressContent createState() => ProgressContent();
}

class ProgressContent extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        // print("progress back");
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => wevViewPage(),
        //   ));
        return Future.value(false);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(

            stops: const [0.1, 0.5, 0.7, 0.9],
            colors: [
              AppTheme_color2,
              AppTheme_color3,
              AppTheme_color3,
              AppTheme_color2,
            ],
            tileMode: TileMode.mirror,
          ),
          image:const DecorationImage(
            image: AssetImage("assets/back.png",),fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              height: MediaQuery.of(context).size.width * 0.50,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Center(
                      child: CircularProgressIndicator(
                    backgroundColor: AppTheme_color2,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.black),
                  ))),
            ),
          ),
        ),
      ),
    );
  }
}
