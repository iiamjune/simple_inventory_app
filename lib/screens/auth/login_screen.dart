import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/login_service.dart';
import 'package:flutter_application_1/widgets/appbar.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/auth_page_footer.dart';
import 'package:flutter_application_1/widgets/textformfield.dart';

import '../../constants/labels.dart';
import '../../services/navigation_service.dart';
import '../../services/shared_preferences_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? email;
  String? password;
  Map<String, dynamic>? data = {};
  Map<String, dynamic>? errors = {};
  String? errorMessage;
  String? emailError;
  String? passwordError;
  String? token;
  bool success = false;
  bool isProcessing = false;

  /// It's making an API call to a server, and if the response contains an error, it will store the error
  /// message in a variable
  void getLoginData() async {
    setState(() {
      isProcessing = true;
    });
    data = (await LoginService(context)
        .login(emailController.text, passwordController.text));
    setState(() {
      if (data!.containsKey("message")) {
        success = false;
        errorMessage = data?["message"];
        emailError = null;
        passwordError = null;
        errors = null;
        if (data!.containsKey("errors")) {
          errors = data?["errors"];
        }
      }
      if (data!.containsKey("token")) {
        success = true;
        token = data?["token"];
      }
    });
    setState(() {
      if (errors != null) {
        storeEmailError(errors);
        storePasswordError(errors);
      }
    });
  }

  /// It waits for 2 seconds, then checks if the login was successful, if it was, it saves the token to
  /// the shared preferences and navigates back to the home screen, if it wasn't, it shows an error
  /// message
  void loginProcess() {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (success) {
        SharedPref(context).setString("token", token!);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Token: ${token!}")));
        Navigation(context).backToProductList();
      } else {
        errorMessage != null
            ? ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(errorMessage!)))
            : null;
      }
    });

    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (!success) {
        setState(() {
          isProcessing = false;
        });
      }
    });
  }

  /// It gets login data and then processes the login.
  void login() {
    getLoginData();
    loginProcess();
  }

  /// If the errors map contains a key called email, then set the emailError variable to the first
  /// element of the list that is the value of the email key
  ///
  /// Args:
  ///   errors (Map<String, dynamic>): The errors returned from the API.
  void storeEmailError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("email")) {
      emailError = errors["email"][0];
    }
  }

  /// If the errors map contains a key called password, then set the passwordError variable to the first
  /// element of the password key's value
  ///
  /// Args:
  ///   errors (Map<String, dynamic>): The errors returned from the server.
  void storePasswordError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("password")) {
      passwordError = errors["password"][0];
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PageAppBar(Label.login),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.login,
                  color: Colors.indigo[600],
                  size: 80.0,
                ),
                SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      AuthTextField(
                        label: Label.email,
                        controller: emailController,
                        errorText: emailError,
                      ),
                      const SizedBox(height: 20.0),
                      AuthTextField(
                        label: Label.password,
                        obscureText: true,
                        controller: passwordController,
                        errorText: passwordError,
                      ),
                    ],
                  ),
                ),
                MainButton(
                  buttonLabel: Label.login,
                  isProcessing: isProcessing,
                  process: login,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                AuthPageFooter(
                  label: Label.dontHaveAnAccount,
                  navigation: () {
                    Navigation(context).goToRegistration();
                  },
                  buttonLabel: Label.register,
                )
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
