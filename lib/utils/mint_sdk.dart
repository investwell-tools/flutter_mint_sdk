library mint_sdk;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MintSdk{

  /// [MethodChannel] use to communicate with the platfoem side.
  /// note once lib deployed then no need to set methodchannel manually this will auto configure

  static const MethodChannel _channel =MethodChannel("app/mint");

   Future<bool?> mintSDk({
    required String sso,
    required String fcmToken,
    required String domain,
    String? packageNameWithClass
}) async {
    // var  message ="";
    // if(sso.isEmpty){
    // message ="SSO Can't be empty.";
    // }
    // if(fcmToken.isEmpty){
    //   message ="fcmToken Can't be empty.";
    // }
    //
    // if(domain.isEmpty){
    //   message ="domain Can't be empty.";
    // }

    // default we pass flutter main screen show packageNameWithClass is optional
    // if(packageNameWithClass!.isEmpty){
    //   message ="packageNameWithClass Can't be empty.";
    // }
    /// init mint required data
    /// pass [sso], [fcmToken] and [packageNameWithClass] for mint sdk
  final Map<String,dynamic> params =  <String,dynamic>{
    'ssoToken':sso,
    'fcmToken':fcmToken,
    'domain':domain,
    'currentClass':packageNameWithClass
  };
  try{
    final bool? res = await _channel.invokeMethod<bool>('openMintLib', params);
    return res;
  }catch(e){
    print('Failed to invoke SDK: $e');
    return null;
  }
  }


}

typedef MintSdkBuilder = Widget Function(
    BuildContext context, Widget child);
