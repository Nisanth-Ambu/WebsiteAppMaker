import 'dart:async';
import 'dart:io';


import 'package:WebSiteAppMaker/colors_code.dart';
import 'package:WebSiteAppMaker/web_view_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

     if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
        //  print(request);
          return null;
        },
      );
    }
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () async {
      // await cookieManager.setCookies([Cookie('cookieName', 'DEVICE=android')]);
      // print("Loading next page");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const wevViewPage(),
      ));
    });
//////////////////////////////////
/////////////////////////////////
//////////////////////////////////
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Container(
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
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: LogoViewer(),
        ),
      ),
    );
  }
}

class LogoViewer extends StatelessWidget {
  const LogoViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .90,
      height: MediaQuery.of(context).size.width * .70,
      child: Center(
        child: SizedBox(
          width: double.maxFinite,
          child: Stack(children: [
            Container(
              alignment: const Alignment(-0.1, 0),
              margin: const EdgeInsets.only(right: 4, top: 8),
              child: Opacity(
                  child:
                      Image.asset('assets/1024x500.png', color: Colors.black),
                  opacity: 0.2),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 4,
              ),
              alignment: const Alignment(0, 0),
              child: Image.asset(
                'assets/1024x500.png',
              ),
            )
          ]),

          // Stack(
          //   children: [
          //     Card(
          //       color: Colors.blue.shade900,
          //       shape:
          //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //       elevation: 4,
          //       child: const ClipRRect(
          //         borderRadius: BorderRadius.all(Radius.circular(10)),
          //         child: Image(
          //           image: AssetImage('assets/1024x500.png'),
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
