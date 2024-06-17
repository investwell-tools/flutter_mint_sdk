// ignore_for_file: prefer_const_constructors, empty_constructor_bodies, unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:mintsamplle/utils/mint_sdk.dart';


const platform = MethodChannel('mint-android-app');
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
  
 
}


class MyHomePage extends StatefulWidget{
   const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mint SDK'),
        ),
        body: Center(
          child: ElevatedButton(onPressed: (){
            // generateAuth('');
            invokeSDK(context);
          }, child: Text('Invoke Mint SDK')),
        ),
      ),
    );
  }

void invokeSDK(BuildContext context) async{
    var sdk = MintSdk();
    bool? result = await sdk.mintSDk(sso: sso, fcmToken: fcmToken, domain: domain)
 
  }
Future<dynamic> generateAuth(String loginType) async {
 // Show progress indicator
  setState(() {
    _isLoading = true;
  });

  // API endpoint
  final String url = "https://spvithlani.investwell.app/api/aggregator/auth/getAuthorizationToken";

  try {
    // Make POST request

 HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    
     Map<String, String> jsonBody = {
              "authName": "spvithlani",
        "password": "spvithlani123"
      };
    final urls = Uri.parse(url);
    final response = await http.post(urls, body: jsonBody);

    // Handle response
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Check response status
      if (jsonResponse['status'] == 0) {
        final result = jsonResponse['result'];
        final String token = result['token'];
       print('Success: ${jsonResponse.toString()}');
        // Call another function with token
        getAuthenticationKey(token, "broker");
      } else {
               print('Error: ${jsonResponse.toString()}');
        showToastMessage("Error: ${jsonResponse['message']}");
      }
    } else {
      showToastMessage("Error: ${response.reasonPhrase}");
             print('Success: ${response.reasonPhrase}');
    }
  } catch (error) {
    showToastMessage("Error: $error");
           print('Success: ${error}');
  } finally {
    // Hide progress indicator
    setState(() {
      _isLoading = false;
    });
  }
}

Map<String, String> getParams(String token, String type) {
  Map<String, String> params = {
    "token": token,
    "username": type.isEmpty ? "akbpv3469k" : "spvithlani",
  };

  return params;
}

Future<dynamic> getAuthenticationKey(String token,String type) async {

 // Show progress indicator
  setState(() {
    _isLoading = true;
  });

  // API endpoint
  final String url = "https://spvithlani.investwell.app/api/aggregator/auth/getAuthenticationKey";

  try {
    // Make POST request
 HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    final urls = Uri.parse(url);
     Map<String, String> jsonBody = getParams(token, type);
    final response = await http.post(urls, body: jsonBody);

    // Handle response
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      
      // Check response status
      if (jsonResponse['status'] == 0) {
        final result = jsonResponse['result'];
        final String SSOToken = result['SSOToken'];
       print('Success 2 and openSDK: ${jsonResponse.toString()}');
        // invoke sdk
        //preprare jsonobject 
        Map<String,String> jso= {
          'ssoToken':'$SSOToken',
          'fcmToken':'your_fcm_token',
          'domain':'spvithlani'
        };
        openMintLib(jso);
      } else {
        showToastMessage("Error: ${jsonResponse['message']}");
               print('Success: ${jsonResponse.toString()}');
      }
    } else {
      showToastMessage("Error: ${response.reasonPhrase}");
             print('Success: ${response.reasonPhrase}');
    }
  } catch (error) {
    showToastMessage("Error: $error");
           print('Success: ${error}');
  } finally {
    // Hide progress indicator
    setState(() {
      _isLoading = false;
    });
  }

}
void showToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}

  void openMintLib(Map<String,String> jsonArray) async{
    try{
      try{
        // await MintUtils.platform.invokeMethod('openMintLib',jsonArray);
      }catch(e){}
    } catch (e) {
      print('Error: $e');
    }
  }


  // void openMintLib(Map<String, String> jso) async{
  //     String jsonString = jsonEncode(jso);
  //     try{
  //       String result = await MethodChannel('$platform').invokeMethod('openMintLib', {'jsonObject': jsonString});
  //
  //
  //     } on PlatformException catch (e) {
  //     // Handle platform exceptions
  //     print('Error invoking method: ${e.message}');
  //   }
  // }
}


