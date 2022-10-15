import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/auth_repository.dart';
import 'package:flutter_application_1/services/shared_preferences_service.dart';
import 'package:flutter_application_1/widgets/appbar.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/auth_page_footer.dart';
import 'package:flutter_application_1/widgets/popup.dart';
import 'package:flutter_application_1/widgets/textformfield.dart';

import '../../constants/labels.dart';
import '../../services/navigation_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  String? name;
  String? email;
  String? password;
  String? passwordConfirmation;
  Map<String, dynamic>? data = {};
  Map<String, dynamic>? errors = {};
  String? errorMessage;
  String? nameError;
  String? emailError;
  String? emailFormatError;
  String? passwordError;
  String? confirmPasswordError;
  String? token;
  bool success = false;
  bool isProcessing = false;

  /// It's making an API call to a server, and if the response contains an error, it will store the error
  /// message in a variable
  void getRegistrationData() async {
    setState(() {
      isProcessing = true;
    });
    setState(() {
      if (emailController.text.isNotEmpty) {
        if (validateEmail(emailController.text)) {
          emailFormatError = null;
          email = emailController.text;
        } else {
          email = "";
          emailFormatError = null;
          emailFormatError = ErrorMessage.invalidEmail;
        }
      } else {
        emailFormatError = null;
        email = emailController.text;
      }
    });

    data = (await AuthRepository(context).register(
      nameController.text,
      email!,
      passwordController.text,
      passwordConfirmationController.text,
    ));

    setState(() {
      if (data!.containsKey("errors")) {
        success = false;
        errorMessage = data?["message"];
        nameError = null;
        emailError = null;
        passwordError = null;
        confirmPasswordError = null;
        errors = null;
        errors = data?["errors"];
        if (errors!.containsKey("email") && emailFormatError != null) {
          errors?["email"].insert(0, emailFormatError);
        }
      }
      if (data!.containsKey("token")) {
        success = true;
        token = data?["token"];
      }
    });
    setState(() {
      if (errors != null) {
        storeNameError(errors);
        storeEmailError(errors);
        storePasswordError(errors);
      }
    });
  }

  /// It waits for 2 seconds, then checks if the registration was successful, if it was, it saves the token to
  /// the shared preferences and opens a success popup widget that will navigate to the home screen, if it wasn't,
  /// it shows an error message
  void registrationProcess() {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (success) {
        SharedPref(context).setString("token", token!);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Token: ${token!}")));
        Popup(context).showSuccess(
          message: Label.registrationSuccessful,
          onTap: () => Navigation(context).backToProductList(),
        );
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

  /// It gets registration data and then it processes the registration.
  void createAccount() {
    getRegistrationData();
    registrationProcess();
  }

  /// If the errors map contains a key called "name", then set the nameError variable to the first
  /// element of the array that is the value of the "name" key
  ///
  /// Args:
  ///   errors (Map<String, dynamic>): The errors returned from the API.
  void storeNameError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("name")) {
      nameError = errors["name"][0];
    }
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

  /// If the password field is empty, and the confirm password field is not empty, then the error
  /// message is stored in the confirm password error variable.
  /// If the password field is not empty, and the confirm password field is empty, then the error
  /// message is stored in the password error variable.
  /// If the password field is empty, and the confirm password field is empty, then the error message is
  /// stored in the password error variable.
  /// If the password field is not equal to the confirm password field, then the error message is stored
  /// in the confirm password error variable
  ///
  /// Args:
  ///   errors (Map<String, dynamic>): Map<String, dynamic>?
  void storePasswordError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("password")) {
      if ((passwordConfirmationController.text.isEmpty) &&
          passwordController.text.isNotEmpty) {
        confirmPasswordError = errors["password"][0];
      }
      if ((passwordConfirmationController.text.isNotEmpty) &&
          passwordController.text.isEmpty) {
        passwordError = errors["password"][0];
      }
      if ((passwordConfirmationController.text.isEmpty) &&
          passwordController.text.isEmpty) {
        passwordError = errors["password"][0];
      }
      if (passwordConfirmationController.text != passwordController.text) {
        confirmPasswordError = errors["password"][0];
      }
    }
  }

  bool validateEmail(String email) {
    final bool result = EmailValidator.validate(email);
    return result;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PageAppBar(Label.registration),
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
                  Icons.app_registration,
                  color: Colors.indigo[600],
                  size: 80.0,
                ),
                SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      AuthTextField(
                        label: Label.name,
                        controller: nameController,
                        errorText: nameError,
                      ),
                      const SizedBox(height: 20.0),
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
                      const SizedBox(height: 20.0),
                      AuthTextField(
                        label: Label.passwordConfirmation,
                        obscureText: true,
                        controller: passwordConfirmationController,
                        errorText: confirmPasswordError,
                      ),
                    ],
                  ),
                ),
                MainButton(
                  buttonLabel: Label.createAccount,
                  isProcessing: isProcessing,
                  process: createAccount,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                AuthPageFooter(
                  label: Label.alreadyHaveAnAccount,
                  navigation: () {
                    Navigation(context).goToLogin();
                  },
                  buttonLabel: Label.login,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
