import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_exeption.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'reset_password';
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  static final auth = FirebaseAuth.instance;
  static late AuthStatus _status;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));

    return _status;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                  const SizedBox(height: 70),
                  Text(
                    'Reset Password ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 65, 65, 65),
                      fontSize: 35.0,
                    ),
                    // style:,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please enter your email address to reset your password.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        isDense: true,
                        fillColor: Colors.white,
                        filled: true,
                        errorStyle: TextStyle(fontSize: 15),
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 88, 207, 108)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0))),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0)),
                            borderSide: BorderSide(
                                width: 3,
                                color: Color.fromARGB(255, 88, 207, 108))),
                        label: Text(
                          "Email",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      obscureText: false,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty email';
                        }
                        return null;
                      },
                      autofocus: false,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(360, 40),
                            backgroundColor: Color.fromARGB(255, 88, 207, 108),
                            shape: const BeveledRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ))),
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            final _status = await resetPassword(
                                email: _emailController.text.trim());
                            if (_status == AuthStatus.successful) {
                              //your logic
                            } else {
                              //your logic or show snackBar with error message

                            }
                          }
                        },
                        child: Text(
                          'Reset password',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  // const Expanded(child: SizedBox()),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height / 20,
                  //   child: Material(
                  //     elevation: 2,
                  //     borderRadius: BorderRadius.circular(20),
                  //     color: Colors.green,
                  //     child: MaterialButton(
                  //       onPressed: () async {
                  //         if (_key.currentState!.validate()) {
                  //           final _status = await resetPassword(
                  //               email: _emailController.text.trim());
                  //           if (_status == AuthStatus.successful) {
                  //             //your logic send success
                  //           } else {
                  //             //your logic or show snackBar with error message send error message

                  //           }
                  //         }
                  //       },

                  //       minWidth: double.infinity,
                  //       child: const Text(
                  //         'Reset PASSWORD',
                  //         style: TextStyle(
                  //             color: Color.fromARGB(255, 0, 0, 0),
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 16,
                  //             fontFamily: 'Poppins'),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
