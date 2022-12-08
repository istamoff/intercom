
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sip_native/sip_native.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _registrationState = "UNKNOWN";
  String _callsState = "UNKNOWN";

  @override
  initState()   {
    SipNative.requestPermissions();
    super.initState();
    initRegistrationStream();
  }

  @override
  void dispose() {
    SipNative.disconnectSip();
    super.dispose();
  }

  initRegistrationStream() {
    try {
      SipNative.registrationStateStream().listen((event) {
        setState(() {
          _registrationState = event.toString();
        });
      });
    } catch (e) {
      print(e.toString());
      EasyLoading.show(status:"Registration stream error\n${e.toString()}" );

    }
  }

  initCallsStream() {
    try {
      SipNative.callsStateStream().listen((event) {
        setState(() {
          _callsState = event.toString();
        });
      });
    } catch (e) {
      print(e.toString());
      EasyLoading.show(status:"Calls stream error\n${e.toString()}" );

    }
  }

  Future<bool> connectToSip(
      String username,
      String password,
      String domain,
      ) async {
    bool response = await SipNative.initSipConnection(
      username: username,
      password: password,
      domain: domain,
    );
    return response;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController domainController = TextEditingController();
  bool response = false ;
  @override
  Widget build(BuildContext context) {
    return   SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Intercom'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text('Registration state: $_registrationState\n'),
                ),
                Text('Calls state: $_callsState\n'),
                //   Wrap(
                //    spacing: 5,
                //    children: [
                ElevatedButton(
                  child: Text("1. Get permissions"),
                  onPressed: () async {
                    await SipNative.requestPermissions();
                  },
                ),
                TextFormField(
                    controller: nameController ,
                    keyboardType: TextInputType.text, // Only numbers can be entered
                    style: const TextStyle(fontSize: 14),

                    onChanged: (value){

                      setState(() {
                      });

                    },

                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,

                      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      hintText: "123728402195154",
                      // hintStyle: TextStyle(color: MyColors.baseGreyDeeper),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      focusedBorder:  OutlineInputBorder(

                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      labelText: 'Login',
                      // labelStyle:  MyStyles.profileText.copyWith(color: MyColors.hintTextColor ,fontSize: 12),
                    )
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: passwordController ,
                    keyboardType: TextInputType.text, // Only numbers can be entered
                    style: const TextStyle(fontSize: 14),

                    onChanged: (value){

                      setState(() {
                      });

                    },

                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,

                      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      hintText: "26feaeec90eb",
                      // hintStyle: TextStyle(color: MyColors.baseGreyDeeper),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      focusedBorder:  OutlineInputBorder(

                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      labelText: 'Password',
                      // labelStyle:  MyStyles.profileText.copyWith(color: MyColors.hintTextColor ,fontSize: 12),
                    )
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: domainController ,
                    keyboardType: TextInputType.text, // Only numbers can be entered
                    style: const TextStyle(fontSize: 14),

                    onChanged: (value){

                      setState(() {
                      });

                    },

                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,

                      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      hintText: "93.125.121.70",
                      // hintStyle: TextStyle(color: MyColors.baseGreyDeeper),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      focusedBorder:  OutlineInputBorder(

                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      labelText: 'Domain',
                      // labelStyle:  MyStyles.profileText.copyWith(color: MyColors.hintTextColor ,fontSize: 12),
                    )
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text("2. SIP connect"),
                  onPressed: () async {
                    String username = nameController.text.isEmpty  ? "1397": nameController.text;
                    String password = passwordController.text.isEmpty ? "123456789":passwordController.text;
                    String domain =  domainController.text.isEmpty ? "11.91.128.5":domainController.text;
                    response = await connectToSip(
                      username,
                      password,
                      domain,
                    );

                    setState(() {});
                    await  EasyLoading.show(status:"Sip connect response: $response" ,dismissOnTap: true);

                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text("3. Init registration stream"),
                  onPressed: () {
                    initRegistrationStream();
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  child: Text("3. SIP disconnect"),
                  onPressed: () async {
                    await SipNative.disconnectSip();
                  },
                ),
                Text('if SIP will connect, the button below will change color !'),
                SizedBox(
                  height: 30,
                ),
                response ?   ElevatedButton(
                  child: Text("Init call"),
                  onPressed: () async {
                    bool res = await SipNative.initCall("254727751850");
                    if (res) {
                      initCallsStream();
                    }
                  },
                ) : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey
                  ),
                  child: Text("Init call"),
                  onPressed: () async {
                    bool res = await SipNative.initCall("254727751850");
                    if (res) {
                      initCallsStream();
                    }
                  },
                ),
                // ],
                // ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
