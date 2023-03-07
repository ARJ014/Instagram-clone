import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freelancer/page/loginscreen.dart';
import 'package:freelancer/resourses/auth.dart';
import 'package:freelancer/utils/colors.dart';
import 'package:freelancer/utils/utils.dart';
import 'package:freelancer/widgets/text_input_Widget.dart';
import 'package:image_picker/image_picker.dart';

import '../responsive/phonescreen.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webscreen.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final email = TextEditingController();

  final password = TextEditingController();

  final username = TextEditingController();

  final bio = TextEditingController();

  Uint8List? image;
  bool _isloading = false;

  void imagePick() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      image = im;
    });
  }

  void signIn() async {
    setState(() {
      _isloading = true;
    });
    String res = await Auth().signIn(
        email: email.text,
        password: password.text,
        username: username.text,
        bio: bio.text,
        file: image!);

    if (res != "Success") {
      setState(() {
        _isloading = false;
      });
      showSnackBar(res, context);
    } else {
      setState(() {
        _isloading = false;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: ((context) =>
                  const Responsive_layout(PhoneScreen(), WebScreen()))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: webBackgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),

              SvgPicture.asset(
                'images/logo.svg',
                color: primaryColor,
                height: 64,
              ),

              const SizedBox(height: 24),
              Stack(
                children: [
                  image != null
                      ? CircleAvatar(
                          radius: 64, backgroundImage: MemoryImage(image!))
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png'),
                        ),
                  Positioned(
                      bottom: -8,
                      right: 10,
                      child: IconButton(
                          onPressed: () {
                            imagePick();
                          },
                          icon: const Icon(Icons.add_a_photo)))
                ],
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                input: username,
                hintText: "Username",
                keyboardType: TextInputType.text,
              ),

              const SizedBox(height: 24),
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
              TextFieldInput(
                input: bio,
                hintText: "Your Bio",
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 24),
              InkWell(
                onTap: signIn,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(5),
                    color: blueColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _isloading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Sign in"),
                ),
              ),

              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   validator: (value) =>
              //       value != null && value.length < 6 ? "At least 6" : null,
              // ),

              const SizedBox(height: 12),
              Flexible(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const LoginPage())));
                      },
                      child: const Text(
                        " Log In",
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
