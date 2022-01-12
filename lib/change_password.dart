import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController repassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController oldpassword = TextEditingController();
  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  auth.User? user = auth.FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0),
      appBar: AppBar(
      backgroundColor:  Colors.yellow[800],),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              // borderRadius: BorderRadius.circular(13),
              color: Colors.white),
          height: 300,
          width: 300,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: oldpassword,
                    decoration: const InputDecoration(hintText: 'old Password'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter your old password';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: newpassword,
                    decoration: const InputDecoration(hintText: 'new Password'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter your new password';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: repassword,
                    decoration:
                        const InputDecoration(hintText: 'Retype Password'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter your new password';
                      }
                      if (newpassword.text != val) {
                        return 'not Matched';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 15, right: 15)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromRGBO(19, 26, 44, 1.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(
                                              19, 26, 44, 1.0))))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          change_password();
                        }
                      },
                      child: const Text(
                        'Change',
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.transparent,
        content: Center(
          child: SpinKitFadingCube(
            color: Colors.blue,
            size: 50,
          ),
        ),
      ),
    );
  }

  Future change_password() async {
    showLoadingDialog(context);
    AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email.toString(), password: oldpassword.text);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      var a = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      await a.user!.updatePassword(newpassword.text);
      await a.user!.reload();
      setState(() {
        Navigator.of(context).pop();
        showBar(context, 'your password is updated ', 1);
      });
    } on auth.FirebaseAuthException catch (e) {
      setState(() {
        Navigator.of(context).pop();
        oldpassword.clear();
        showBar(context, 'your password not correct', 0);
      });
    }
  }
}
