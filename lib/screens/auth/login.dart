import 'dart:ui';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import '../../utils/animations.dart';

import '../../data/bg_data.dart';
import '../../utils/text_utils.dart';
import '../../helper/api.dart';
import '../home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  int selectedIndex = 0;
  bool showOption = false;

  void loginUser() async {
    final data = {
      'username': username.text.toString(),
      'password': password.text.toString(),
    };
    print(data);
    final result = await API().postRequest(route: '/login', data: data);
    final response = jsonDecode(result.body);
    print(response);
    if (response['success'] == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt('user_id', response['user']['id']);
      await preferences.setString('name', response['user']['name']);
      await preferences.setString('email', response['user']['email']);
      await preferences.setString('token', response['token']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 49,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                child: showOption
                    ? ShowUpAnimation(
                        delay: 100,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: bgList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: selectedIndex == index ? Colors.white : Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                        bgList[index],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    : const SizedBox()),
            const SizedBox(
              width: 20,
            ),
            showOption
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = false;
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ))
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = true;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            bgList[selectedIndex],
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(bgList[selectedIndex]), fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Container(
          height: 400,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Center(
                          child: TextUtil(
                        text: "Login",
                        weight: true,
                        size: 30,
                      )),
                      const Spacer(),
                      TextUtil(
                        text: "Username",
                      ),
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))),
                        child: TextFormField(
                          controller: username,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.account_box,
                              color: Colors.white,
                            ),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextUtil(
                        text: "Password",
                      ),
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))),
                        child: TextFormField(
                          obscureText: true,
                          controller: password,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextUtil(
                            text: "Remember Me",
                            size: 12,
                            weight: true,
                          ))
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          loginUser();
                        },
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                          alignment: Alignment.center,
                          child: TextUtil(
                            text: "Log In",
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // Container(
                      //   height: 40,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                      //   alignment: Alignment.center,
                      //   child: TextUtil(
                      //     text: "Log In",
                      //     color: Colors.black,
                      //   ),
                      // ),
                      const Spacer(),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
