import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freelancer/page/register.dart';
import 'package:freelancer/resourses/auth.dart';
import 'package:freelancer/responsive/global.dart';
import 'package:freelancer/utils/colors.dart';
import 'package:freelancer/utils/utils.dart';
import 'package:freelancer/widgets/text_input_Widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  void loginUser() async {
    setState(() {
      _isloading = true;
    });
    String res = await Auth().LogIn(email: email.text, password: password.text);
    setState(() {
      _isloading = false;
    });
    if (res == 'Success') {
    } else {
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > maxscreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
              ),
              SvgPicture.asset(
                'images/logo.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 54),
              TextFieldInput(
                input: email,
                hintText: "Enter Your Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                input: password,
                hintText: "Password",
                keyboardType: TextInputType.text,
                obsecureText: true,
              ),
              const SizedBox(height: 24),
              InkWell(
                  onTap: loginUser,
                  child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(5),
                        color: blueColor,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: _isloading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Log in"))),
              const SizedBox(height: 12),
              Flexible(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Do not have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => Register())));
                      },
                      child: const Text(
                        " Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: blueColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
