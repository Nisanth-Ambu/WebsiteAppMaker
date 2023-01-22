import 'dart:developer';

import 'package:WebSiteAppMaker/main.dart';
import 'package:WebSiteAppMaker/progress_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'colors_code.dart';

// ignore: camel_case_types
class wevViewPage extends StatefulWidget {
  const wevViewPage({
    Key? key,
  }) : super(key: key);
  @override
  _wevViewPageState createState() => _wevViewPageState();
}

var count = 0;
late InAppWebViewController _webViewController;

// ignore: camel_case_types
class _wevViewPageState extends State<wevViewPage> {
  final key = GlobalKey();
  final String kmainUrl = "https://hdtoday.cc/";
  late String mainUrl;
  bool useSafeArea = true;
  late String runningurl;
  double progress = 0;

  bool prg = false;

  valueChange(int c) {
    //  print('value $c');
    setState(() {
      count = c;
    });
  }

  Future<bool> _onBack() async {
    bool goBack = false;

    var value =
        await _webViewController.canGoBack(); // check webview can go back

    if (value) {
      _webViewController.goBack(); // perform webview back operation

      return false;
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirmation ', style: TextStyle(color: AppTheme_color)),
          // Are you sure?
          content: const Text('Do you want exit app ? '),
          // Do you want to go back?
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);

                setState(() {
                  goBack = false;
                });
              },

              child: const Text('No'), // No
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pop();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                setState(() {
                  goBack = true;
                });
              },

              child: const Text('Yes'), // Yes
            ),
          ],
        ),
      );

      if (goBack) Navigator.pop(context); // If user press Yes pop the page

      return goBack;
    }
  }

  // _loadHtmlFromAssets() async {
  //   String fileText = await rootBundle.loadString('assets/webpage/error.html');

  //   _webViewController.loadUrl(
  //       urlRequest: URLRequest(url: Uri.tryParse(fileText))
  //       // Uri.dataFromString(fileText,
  //       //         mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //       //     .toString()
  //       );
  // }

  bool showErrorPage = false;
  bool hiderError = false;
  String netError = "No Internet Connection";
  void showError() {
    setState(() {
      showErrorPage = true;
    });
  }

  void hideError() {
    setState(() {
      showErrorPage = false;
    });
  }

  bool lock = false;

  void saveToSharedPreference() async {
    var value = newUrlController.text.trim();
    if (value.isEmpty) {
      return;
    }
    mainUrl = value;
    runningurl = value;
    var shared = await SharedPreferences.getInstance();
    shared.setString(sharedKey, value);
    _webViewController.clearCache();
    _webViewController.loadUrl(urlRequest: URLRequest(url: Uri.parse(value)));
    Fluttertoast.showToast(msg: "Saved");
  }

  void getUrlFromShared() async {
    var shared = await SharedPreferences.getInstance();
    String? url = shared.getString(sharedKey);
    runningurl = url ?? kmainUrl;
    mainUrl = url ?? kmainUrl;
    loading = false;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  bool loading = true;

  void resetAll() async {
    var shared = await SharedPreferences.getInstance();
    shared.remove(sharedKey);
    mainUrl = kmainUrl;
    runningurl = kmainUrl;
    _webViewController.clearCache();
    _webViewController.loadUrl(
        urlRequest: URLRequest(url: Uri.parse(kmainUrl)));
    Fluttertoast.showToast(msg: "restart app to take effect");
  }

  final sharedKey = "sharedUrl";
  final newUrlController = TextEditingController();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    getUrlFromShared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Orientation orientation = MediaQuery.of(context).orientation;
    return WillPopScope(
      // ignore: missing_returnwidget
      // ignore: missing_return
      onWillPop: () async {
        return _onBack();
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/back.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              color: Colors.deepOrangeAccent,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: newUrlController,
                      decoration: const InputDecoration(
                          hintText: "New website Url",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          child: const AutoSizeText("Save"),
                          onPressed: saveToSharedPreference,
                        )),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: ElevatedButton(
                          child: const AutoSizeText("Reset"),
                          onPressed: resetAll,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  color: Colors.black,
                  constraints: const BoxConstraints.expand(),
                  child: SafeArea(
                    top: useSafeArea,
                    bottom: useSafeArea,
                    left: useSafeArea,
                    right: useSafeArea,
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Stack(
                            children: [
                              InAppWebView(
                                onEnterFullscreen: (_) {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.landscapeLeft,
                                    DeviceOrientation.landscapeRight
                                  ]);
                                  setState(() {
                                    useSafeArea = false;
                                  });
                                },
                                onExitFullscreen: (_) {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitDown,
                                    DeviceOrientation.portraitUp
                                  ]);
                                  setState(() {
                                    useSafeArea = true;
                                  });
                                },
                                initialUrlRequest:
                                    URLRequest(url: Uri.parse(mainUrl)),
                                initialOptions: InAppWebViewGroupOptions(
                                    android: AndroidInAppWebViewOptions(
                                      safeBrowsingEnabled: true,
                                      saveFormData: true,
                                      useHybridComposition: true,
                                      disableDefaultErrorPage: true,
                                    ),
                                    crossPlatform: InAppWebViewOptions(
                                      useShouldOverrideUrlLoading: true,
                                      supportZoom: true,
                                      javaScriptCanOpenWindowsAutomatically:
                                          false,
                                    )),
                                onWebViewCreated:
                                    (InAppWebViewController controller) {
                                  _webViewController = controller;
                                },
                                shouldOverrideUrlLoading:
                                    (controller, request) async {
                                  var url = request.request.url.toString();
                                  // print("######## OVERRIDE ############");
                                  // print("URL :$url");

                                  bool value = url.startsWith(mainUrl);

                                  //  controller.webStorage.localStorage.clear();
                                  // if (url.startsWith("refresh:URL")) {
                                  //   controller.clearCache();
                                  //   url = "https://idukki.live";
                                  //   controller.loadUrl(url: "https://idukki.live");
                                  //   return ShouldOverrideUrlLoadingAction.ALLOW;
                                  // }
                                  if (!value) {
                                    // if (url.startsWith("viber://forward?text=")) {
                                    //   // print("######## OVERRIDED ############\n");

                                    //   return NavigationActionPolicy.CANCEL;
                                    // }
                                    // controller.android.clearHistory();
                                    // controller.clearFocus();
                                    // var index=await controller.webStorage.sessionStorage.length();
                                    // print("${index} ////OOOOOOOOOOOO///// ${controller.webStorage.sessionStorage.key(index: index!)}" );
                                    return NavigationActionPolicy.CANCEL;
                                    //  else if (await canLaunch(url)) {              //intent to open url in outside app
                                    //   // Launch the App
                                    //   await launch(
                                    //     url,
                                    //   );
                                    //   // and cancel the request
                                    //   return NavigationActionPolicy.CANCEL;
                                    // }
                                  } else {
                                    return NavigationActionPolicy.ALLOW;
                                  }
                                },
                                onLoadError: (controller, url, code, message) {
                                  //    print("######## ERROR ############");
                                  // print("URL :$url");
                                  // print("CODE :$code");
                                  // print("message :$message");
                                  // print("ORG URL :${this.url}");
                                  // print("######## ERROR END ############\n");
                                  hiderError = true;
                                  if (message
                                      .contains("INTERNET_DISCONNECTED")) {
                                    setState(() {
                                      netError = "No Internet Connection";
                                    });
                                  } else {
                                    setState(() {
                                      netError = "Something Went Wrong";
                                    });
                                  }

                                  showError();
                                  // _loadHtmlFromAssets();
                                },
                                onLoadHttpError:
                                    (controller, url, statusCode, description) {
                                  // print("######## ERROR ############");
                                  // print("URL :$url");
                                  // print("CODE :$statusCode");
                                  // print("message :$description");
                                  // print("ORG URL :${this.url}");
                                  // print("######## ERROR END ############\n");
                                  hiderError = true;
                                  setState(() {
                                    netError = "Something Went Wrong";
                                  });

                                  showError();
                                },
                                onScrollChanged:
                                    (InAppWebViewController controller, int x,
                                        int y) {},
                                onLoadStart: (controller, url) {
                                  setState(() {
                                    if (url!
                                        .toString()
                                        .startsWith("refresh:URL")) {
                                      controller.clearCache();
                                      runningurl = mainUrl;

                                      controller.loadUrl(
                                          urlRequest: URLRequest(
                                              url: Uri.parse(runningurl)));
                                      return;
                                    }
                                    bool value =
                                        url.toString().startsWith(mainUrl);
                                    if (value) {
                                      runningurl = url.toString();
                                    }
                                  });
                                },
                                onLoadStop: (controller, url) async {
                                  setState(() {
                                    if (url!
                                        .toString()
                                        .startsWith("refresh:URL")) {
                                      // controller.clearCache();
                                      runningurl = mainUrl;
                                      controller.loadUrl(
                                          urlRequest: URLRequest(
                                              url: Uri.parse(runningurl)));
                                      return;
                                    }
                                    bool value =
                                        url.toString().startsWith(mainUrl);
                                    if (value) {
                                      runningurl = url.toString();
                                    }
                                  });
                                },
                                onProgressChanged:
                                    (InAppWebViewController controller,
                                        int progress) {
                                  setState(() async {
                                    this.progress = progress / 100;
                                    // print(this.progress);

                                    if (this.progress >= .7) {
                                      setState(() {
                                        if (!hiderError) {
                                          hideError();
                                        }
                                      });
                                    }

                                    if (prg == false && this.progress < 1) {
                                      prg = true;
                                      showDialog(
                                        barrierColor: Colors.transparent,
                                        context: context,
                                        useSafeArea: false,
                                        // child: Progress(),
                                        barrierDismissible: false,
                                        builder: (context) => const Progress(),
                                      );
                                    } else if (prg == true &&
                                        this.progress >= 1) {
                                      Navigator.of(context).pop();
                                      prg = false;
                                      var result =
                                          await _webViewController.getHtml();
                                      log("$result");
                                    }
                                    valueChange(progress);
                                  });
                                },
                              ),
                              if (showErrorPage)
                                Center(
                                  child: Container(
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const LogoViewer(),
                                        Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: Text(netError),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: ElevatedButton(
                                              child: const Text(
                                                " Try Again ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                hiderError = false;
                                                _webViewController.reload();
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          AppTheme_color),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                          side: BorderSide(
                                                              color:
                                                                  AppTheme_color))))),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                const SizedBox(height: 0, width: 0),
                            ],
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.topRight,
                        //   child: Container(
                        //     child: IconButton(
                        //       color: Colors.blue,
                        //         icon: Container(
                        //           decoration: BoxDecoration(
                        //             color: Colors.black,
                        //             shape: BoxShape.circle
                        //
                        //           ),
                        //           padding: EdgeInsets.all(4),
                        //           child: Icon(lock == true ? Icons.lock : Icons.crop_rotate,
                        //
                        //               color: Colors.grey, size: 20.0),
                        //         ),
                        //         onPressed: () {
                        //           setState(() {
                        //             print("rotation=$orientation");
                        //             if (lock) {
                        //               //unlock
                        //               //
                        //
                        //               SystemChrome.setPreferredOrientations([
                        //                 DeviceOrientation.portraitDown,
                        //                 DeviceOrientation.portraitUp
                        //               ]);
                        //             } else {
                        //               //lock
                        //               SystemChrome.setPreferredOrientations([
                        //                 DeviceOrientation.landscapeLeft,
                        //                 DeviceOrientation.landscapeRight,
                        //               ]);
                        //             }
                        //             lock = !lock;
                        //           });
                        //         }),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
