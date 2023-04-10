import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CustomLogo(),
                //
                _Form(),
                //
                CustomTexts(
                    text1: "I already have an account",
                    text2: 'Login',
                    routeName: 'login')
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Form(
        child: Column(
          children: [
            CustomInput(
              title: 'Name',
              iconData: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textController: nameController,
              obscureText: false,
            ),
            //
            const SizedBox(height: 20),
            //
            CustomInput(
              title: 'Email',
              iconData: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textController: emailController,
              obscureText: false,
            ),
            //
            const SizedBox(height: 20),
            //
            CustomInput(
              title: 'Password',
              iconData: Icons.lock_outline,
              keyboardType: TextInputType.emailAddress,
              textController: passwordController,
              obscureText: true,
            ),
            //
            const SizedBox(height: 30),
            //
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      offset: const Offset(0, 5),
                      blurRadius: 5)
                ],
              ),
              child: CustomButton(
                text: 'Register',
                onPressed: () {
                  //
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
