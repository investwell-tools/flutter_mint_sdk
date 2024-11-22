**Mint SDK Gradle File Implementation**

Version: 7 | Updated on 19th Nov, 2024

***

You can add the Investwell Mint app to your existing mobile app using this document.

**Step 1.** Add the JitPack repository to your build file

Add it in your root build.gradle at the end of repositories:

allprojects {

repositories {

...

maven { url 'https\://jitpack.io' }

}

}

**Step 2**. Add the dependency

dependencies { implementation 'com.github.investwell-tools:mint-android-app:replace\_with\_latest\_version'}

**Latest Version:**

**✅ Build artifacts: 1.1.alpha14**

**Add into build.gradle(:app)/build....kts(:app)**

implementation("com.github.investwell-tools:mint-android-app:1.1.alpha14")****

**com.github.investwell-tools:mint-android-app:1.1.alpha14**

**Step 3**. Add the token to $HOME/.gradle/gradle.properties

authToken=jp\_r9me618aib27fnsqpnfo3i5hg4\
\
// Ask for the latest authToken, if this doesn’t work

\
\
\
\


Then use authToken as the username in your build.gradle:// at setting level or app level 

Gradle version stable below 8.0 

build.gradle(:android)/build.gradle.kts(:android)

\


allprojects {

    repositories {

        google()

        mavenCentral()

        maven { url 'https\://www\.jitpack.io'

            credentials {

                username authToken

            }

        }

    }

}

\


**In Case of (Kotlin) DSL**:  (Optional) You may need to approve JitPack Application on GitHub

**Mint SSO Implementation:**

**Step 1:**

Add in your manifest file required 

For Native Apps

Instead of Application extend AppApplication

For flutter required to mention it in your Android Manifest file

android:allowBackup="false"

tools:replace="android:allowBackup"

android:dataExtractionRules="@xml/data\_extraction\_rules"

android:name="investwell.activity.AppApplication"

**->** Follow the Documentation for SSO Token 

[**SSO Login Procedure for Mint.docx**](https://docs.google.com/document/d/1oQkwSGAKciRj1VhnjhS9h0IVCCeFG1JA/edit?usp=sharing\&ouid=107811576253862815873\&rtpof=true\&sd=true)

\


**Step 2:** once you generate the SSOToken then follow the instructions**:**

Pass the ssoToken, fcmToken,classNameWithPackage 

**Example:**

**ssoToken** = 8ff7b6dddb12407dcd0cb3d1fcdabee60b6107863019725689705b587ebb817a

**fcmToken** =  your\_app\_fcmToken

**classWithPackage** = “com.example.sample.ManiActivity”

\
\


private fun invokeSDK(sso: String,fcmToken:String,domain:String,classWithPackage:String= "${this\@MainActivity.packageName}.MainActivity") {

        val mintSdk = MintSDK(this\@MainActivity)

        minced.invokeMintSDK(sso,fcmToken,domain,classWithPackage)

    }

**Note:** In case of getting manifest file provider error, Then please add

 ****

       tools:replace="android:resource

\


**Mint SDK for Flutter implementation**

Note: Flutter version below 3.8.0

**✅ Build artifacts: 1.1.alpha14**

 ****

invokeMintSDKForFlutter()

Accepting arguments 

1. Sso

2. fcmToken

3. domain

\


**Step1. Create a dart class**

class MintUtils{

  static const platform = const MethodChannel('mint-android-app');

}

**bool isPlatformAndroid() {**

  **return Platform.isAndroid;**

**}**

**Step2. Create a dart function where you want to invoke mintSDK**

**void openMintLib(Map\<String, String> jsonArray) async {**

    **try {**

      **try {**

        **if (isPlatformAndroid()) {**

          **await MintUtils.platform.invokeMethod('openMintLib', jsonArray);**

        **} else {**

          **await MintUtils.platform.invokeMethod('openMintLibIOS', jsonArray);**

        **}**

      **} catch (e) {}**

    **} catch (e) {**

      **print('Error: $e');**

    **}**

  **}**

**// in this jsonArray you will pass** 

'ssoToken':'SSOToken',

          'fcmToken':'your\_fcm\_token',

          'Domain':'your\_domain'

**Step 3. implement channel methods at your MainActivity.kt**

private val CHANNEL = "mint-android-app"

 companion object{

        var sdkInitialized:Boolean?=false

    }

**Step 4. implement this code in oncreate()**

GeneratedPluginRegistrant.registerWith(FlutterEngine(this))

        flutterEngine?.dartExecutor?.binaryMessenger?.let {  MethodChannel(it,CHANNEL).setMethodCallHandler { call, result ->

            if (call.method == "openMintLib") {

                try {

                    var domain =""

                    var sso =""

                    var fcm =""

                    val argumentsString: String? = call.arguments?.toString()

                    val tokenResponse = JSONObject(call.arguments.toString())

                    if (tokenResponse.toString().isEmpty()){

                        argumentsString.let { jsonString->

                            try {

                                val newResponse = JSONObject(jsonString)

                                domain = newResponse.optString("domain")

                                sso = newResponse.optString("ssoToken")

                                fcm = newResponse.optString("fcmToken")

                            }catch (e:Exception){e.printStackTrace()}

                        }

                    }else{

                        domain = tokenResponse.optString("domain")

                        sso = tokenResponse.optString("ssoToken")

                        fcm = tokenResponse.optString("fcmToken")

                    }

sdkInitialized = true

                    val intentsdk = Intent(this\@MainActivity, MintSDKInit::class.java)

                    intentsdk.putExtra("route","main")

                    intentsdk.putExtra("sso",sso)

                    intentsdk.putExtra("domain",domain)

                    intentsdk.putExtra("fcm",fcm)

                    startActivity(intentsdk)

                    result.success("Success")

                }catch (e: JSONException) {

                    // Handle JSON parsing error

                    result.error("JSON Parsing Error", e.message, null)

                }

            } else {

                result.notImplemented()

            }

        } }

 ****

**Step 5.**

1. Create a new activity MintSDKInit  with binding 

 buildFeatures {

        dataBinding = true

    }

2. Add launchmode 

 \<activity android:name=".MintSDKInit"

            android:launchMode="singleInstancePerTask"

            />

3. MintSDKInit Activity:

\


class MintSDKInit: FlutterActivity() {

    lateinit var binding: ActivitySdkInitBinding

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)

        binding = DataBindingUtil.setContentView(this\@MintSDKInit,R.layout.activity\_sdk\_init)

//        setContentView(R.layout.activity\_sdk\_init)

        getBundles()

    }

    private fun getBundles(){

       if (intent !=null && intent.hasExtra("route") && MainActivity.sdkInitialized==true){

           val domain :String = intent.getStringExtra("domain")!!

           val fcm :String= intent.getStringExtra("fcm")!!

           val sso :String= intent.getStringExtra("sso")!!

MainActivity.sdkInitialized=false

           invokeSDK(sso = sso, fcmToken = fcm, domain = domain)

       }else{

           // remove activity

if(MainActivity.sdkInitialized==false){

startActivity(this,MainActivity::class.java)\
finish()

}else{

finish()

}

 

       }

    }

    private fun invokeSDK(sso: String,fcmToken:String,domain:String,classWithPackage:String= "${this\@MintSDKInit.packageName}.MintSDKInit") {

        val mintSdk = MintSDK(this\@MintSDKInit)

        mintSdk.invokeMintSDKForFlutter(sso,fcmToken,domain)

    }

    override fun onBackPressed() {

        super.onBackPressed()

removeAllkeys()

        finish()

    }

 private fun checkBackStack(){

        val taskStackBuilder = TaskStackBuilder.create(this\@MintSDKInit)

        taskStackBuilder.addNextIntentWithParentStack(

            Intent(this\@MintSDKInit, MainActivity::class.java)

        )

        taskStackBuilder.startActivities()

    }

    override fun onPause() {

        super.onPause()

        removeAllKeys()

    }

    override fun onDestroy() {

        super.onDestroy()

        removeAllKeys()

    }

    private fun removeAllKeys(){

        if (intent.hasExtra("route")){

            intent.removeExtra("route")

//            intent.removeFlags(Intent.FLAG\_ACTIVITY\_CLEAR\_TASK)

        }

    }

\
\


}

for **✅ Build artifacts: 1.1.alpha14**

 private fun invokeSDK(sso: String,fcmToken:String,domain:String,classWithPackage:String= "${this\@MintSDKInit.packageName}.MintSDKInit") {

        val mintSdk = MintSDK(this\@MainActivity)

        mintSdk.invokeMintSDK(sso,fcmToken,domain,classWithPackage)

    }

for **✅ Build artifacts: 1.1.alpha14** 

    private fun invokeSDK(sso: String,fcmToken:String,domain:String,classWithPackage:String= "${this\@MintSDKInit.packageName}.MintSDKInit") {

        val mintSdk = MintSDK(this\@MintSDKInit)

        mintSdk.invokeMintSDKForFlutter(sso,fcmToken,domain)

    }

\


// for native  

private fun invokeSDK(sso: String,fcmToken:String,domain:String,classWithPackage:String= "${this\@MintSDKInit.packageName}.MintSDKInit") {

        val mintSdk = MintSDK(this\@MainActivity)

        mintSdk.invokeMintSDK(sso,fcmToken,domain,classWithPackage)

    }

**Note: Use ✅ Build artifacts:**

**com.github.investwell-tools:mint-android-app:1.1.alpha14**

**Note:** Code Language Specification & Implementation 

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXczZjwHOBOta2gAKCyyemF18FQH5yy0rBVO-V9kvUzfgFkRJqvgocj5b5Tw-R98NnDNtC7BD8VZBJoBJsreHfDoOb7ktNK2vRvCXAjObCs5aW14ZqSq2-_NsbRb3A-y4_kZThj-7g?key=NGXb516k4R3G8anRchXyYg)

Use the above reference code as per your default language(Kotlin/java)\
\
Checkout Flutter Engine Root View controller for Android\
![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXeqoRkQqrWf6dlWEJHE0f5OC7Dpp6JxZmVUT0pjynXYoPx8a8N-Lkknqz_xweM2YkmzDKEAqrKGFPf73moiP6k2UV5-fVviG3DRmQZzHl62r5lbUPs65-4391lV_WyP5PcbN1ai?key=NGXb516k4R3G8anRchXyYg)

**Kotlin:**

[MainActivity.kt](https://gist.github.com/laxmikant86/1bbb0e4503e929d9f5698ebc6632d024) 

  : Your Default MainActivity  when you are using Kotlin add this code snippet   

[MintSDKInit.kt](https://gist.github.com/laxmikant86/4f61e83d8259c70283daea9c33ed437a)

  : This class helps to manage your navigation as above mention 

AndroidManifest.xml

\<activity

            android:name=".kotlin.MintSDKInit"

            android:exported="false"

            android:launchMode="singleInstancePerTask"

            android:parentActivityName=".kotlin.MainActivity"/>

\
\
\


**Java:**

[MainActivityJ.java](https://gist.github.com/laxmikant86/141013421c09dc967a3dddf098d3e174) (Click here to see code) 

: Your Default MainActivity  when you are using Kotlin add this code snippet   

[MintSDKInitJ.java](https://gist.github.com/laxmikant86/811a42feea2105caf1e8553b2b535d23) (Click here to see code)

  : This class helps to manage your navigation as above mention 

AndroidManifest.xml

\<activity

            android:name=".java.MintSDKInitJ"

            android:exported="false"

            android:launchMode="singleInstancePerTask"

            android:parentActivityName=".java.MainActivityJ"/>

**Ios Integration->**

**Step 1**. **In ios folder go to the pod file and add the below code**

**pod 'MintFramework', :git => 'https\://dharmendraInvestwell\@bitbucket.org/mintframeworkios/mintframework.git', :branch => 'master'**

**Step 2**. **At the end of pod file add**

**post\_install do |installer|**

  **installer.pods\_project.targets.each do |target|**

    **target.build\_configurations.each do |config|**

      **config.build\_settings\['EXPANDED\_CODE\_SIGN\_IDENTITY'] = ""**

      **config.build\_settings\['CODE\_SIGNING\_REQUIRED'] = "NO"**

      **config.build\_settings\['CODE\_SIGNING\_ALLOWED'] = "NO"**

    **config.build\_settings\['ONLY\_ACTIVE\_ARCH'] = 'NO'**

  **config.build\_settings\['IPHONEOS\_DEPLOYMENT\_TARGET'] = '13.0'**

  **config.build\_settings\["EXCLUDED\_ARCHS\[sdk=iphonesimulator\*]"] = "arm64"**

**config.build\_settings\['BUILD\_LIBRARY\_FOR\_DISTRIBUTION'] = 'YES'**

  **xcconfig\_path = config.base\_configuration\_reference.real\_path**

          **xcconfig = File.read(xcconfig\_path)**

          **xcconfig\_mod = xcconfig.gsub(/DT\_TOOLCHAIN\_DIR/, "TOOLCHAIN\_DIR")**

          **File.open(xcconfig\_path, "w") { |file| file << xcconfig\_mod }**

     **end**

  **end**

**end**

**Step 3.run command pod Install**

**Step 4.ios>runner>AppDelegate.swift rplace code**

**import UIKit**

**import Flutter**

**import MintFrameworks**

**@UIApplicationMain**

**@objc class AppDelegate: FlutterAppDelegate {**

  **override func application(**

    **\_ application: UIApplication,**

    **didFinishLaunchingWithOptions launchOptions: \[UIApplication.LaunchOptionsKey: Any]?**

  **) -> Bool {**

    **// let controller : FlutterViewController = navigationController.topViewController as! FlutterViewController**

    **let controller : FlutterViewController = window?.rootViewController as! FlutterViewController**

    **let mintChannel = FlutterMethodChannel(name: "mint-android-app", binaryMessenger: controller.binaryMessenger)**

     ****

    **mintChannel.setMethodCallHandler({**

        **(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in**

        **if call.method == "openMintLibIOS" {**

            **guard let args = call.arguments as? \[String: Any],**

                  **let ssoToken = args\["ssoToken"] as? String,**

                  **let fcmToken = args\["fcmToken"] as? String,**

                  **let domain = args\["domain"] as? String else {**

                **result(FlutterError(code: "INVALID\_ARGS",**

                                    **message: "Invalid arguments",**

                                    **details: nil))**

                **return**

            **}**

            ****

            **self.invokeMintSDK(ssoToken: ssoToken, fcmToken: fcmToken, domain: domain)**

            **result("Success")**

        **} else {**

            **result(FlutterMethodNotImplemented)**

        **}**

    **})**

      **GeneratedPluginRegistrant.register(with: self)**

    **return super.application(application, didFinishLaunchingWithOptions: launchOptions)**

  **}**

  **private func invokeMintSDK(ssoToken: String, fcmToken: String, domain: String) {**

    ****

    **if let rootViewController = UIApplication.shared.windows.first?.rootViewController {**

        **MintSDKInvoke().invokeMintAppFormFlutterApp(domain: domain, token: ssoToken, navigateToview: "", controller: rootViewController)**

    **}**

  **}**

**}**

**Step 5. ios >** open Runner.xcworkspace with xcode Go to build setting > User Script Sandboxing Set to NO

**Step 6**. Do not forget to give permission for location, camera, faceid/biometric, photo library and NSAppTransportSecurity in Info.plist. Ignore if already given.
