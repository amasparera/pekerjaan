import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(),
          child: Image.asset(
            'assest/campaign-creators-gMsnXqILjp4-unsplash.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.1)
              ]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Masuk Menggunakan Google',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 12),
                  child: Text(
                    'Dengan masuk anda menyetujui\nsemua kebijakan yang dibutuhkan Develolper.\nKami membutuhkan informasi nama, email dan\npicture profile ada',
                    style: TextStyle(color: Colors.white.withOpacity(.8)),
                    textAlign: TextAlign.center,
                  ),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    controller.login();
                  },
                  color: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assest/Search.png', width: 24),
                        const SizedBox(width: 4),
                        const Text(
                          'Sing With Google',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .06,
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
