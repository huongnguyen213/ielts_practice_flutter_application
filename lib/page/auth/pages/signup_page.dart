import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/icons.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Khởi tạo các bộ điều khiển cho trường nhập liệu
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  bool _passwordObscure = true; // Biến để ẩn/hiện mật khẩu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello!",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                  ),
                ),
                const Gap(4),
                Text(
                  "Signup to get Started",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: kBodyTextColor,
                  ),
                ),
                const Gap(65),
                RichText(
                  text: TextSpan(
                    text: "Username",
                    children: [
                      TextSpan(
                        text: "*",
                        style: TextStyle(color: kErrorDarkColor),
                      ),
                    ],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: kBodyTextColor,
                    ),
                  ),
                ),
                const Gap(4),
                CupertinoTextField(
                  controller: _usernameController,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  padding: const EdgeInsets.all(15),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kTitleActiveColor,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: kBodyTextColor,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Gap(16),
                RichText(
                  text: TextSpan(
                    text: "Password",
                    children: [
                      TextSpan(
                        text: "*",
                        style: TextStyle(color: kErrorDarkColor),
                      ),
                    ],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: kBodyTextColor,
                    ),
                  ),
                ),
                const Gap(4),
                CupertinoTextField(
                  controller: _passwordController,
                  maxLines: 1,
                  obscureText: _passwordObscure,
                  keyboardType: TextInputType.visiblePassword,
                  padding: const EdgeInsets.all(15),
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          _passwordObscure = !_passwordObscure;
                        });
                      },
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      child: SvgPicture.asset(
                        _passwordObscure ? kIcHidePassword : kIcShowPassword,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kTitleActiveColor,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: kBodyTextColor,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Gap(16),
                RichText(
                  text: TextSpan(
                    text: "Re-Password",
                    children: [
                      TextSpan(
                        text: "*",
                        style: TextStyle(color: kErrorDarkColor),
                      ),
                    ],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: kBodyTextColor,
                    ),
                  ),
                ),
                const Gap(4),
                CupertinoTextField(
                  controller: _cPasswordController,
                  maxLines: 1,
                  obscureText: _passwordObscure,
                  keyboardType: TextInputType.visiblePassword,
                  padding: const EdgeInsets.all(15),
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          _passwordObscure = !_passwordObscure;
                        });
                      },
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      child: SvgPicture.asset(
                        _passwordObscure ? kIcHidePassword : kIcShowPassword,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kTitleActiveColor,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: kBodyTextColor,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Gap(28),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    color: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    onPressed: () async {
                      String username = _usernameController.value.text.trim();
                      String password = _passwordController.value.text.trim();
                      String cPassword = _cPasswordController.value.text.trim();
                      if (username.isEmpty ||
                          password.isEmpty ||
                          password != cPassword) {
                        _showFailureDialog(context);
                      } else {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        List<dynamic> data = jsonDecode(
                            prefs.getString("users") == null
                                ? "[]"
                                : prefs.getString("users").toString());
                        List<User> users = User.decode(data);
                        users.add(User(username: username, password: password));
                        prefs.setString("users", User.encode(users));
                        _showSuccessDialog(context);
                      }
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "or continue with",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: kBodyTextColor,
                    ),
                  ),
                ),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account ? ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kBodyTextColor,
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Hàm hiển thị thông báo lỗi khi đăng ký thất bại
void _showFailureDialog(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('Sign Up failure'),
      content: const Text('Please check inputs field!'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          /// Tham số này cho biết hành động sẽ thực hiện
          /// một hành động phá hoại như xóa và chuyển
          /// màu văn bản của hành động thành màu đỏ.
          isDestructiveAction: true, // Đặt hành động này là phá hủy
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

// Hàm hiển thị thông báo thành công khi đăng ký
void _showSuccessDialog(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('Sign Up success'),
      content: const Text('Please login!'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          /// Tham số này cho biết hành động sẽ thực hiện
          /// một hành động phá hoại như xóa và chuyển
          /// màu văn bản của hành động thành màu đỏ.
          isDefaultAction: true, // Đặt hành động này là mặc định
          onPressed: () {
            Navigator.of(context).pop(); // Đóng dialog
            Navigator.of(context).pop(); // Quay lại màn hình trước
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(username: jsonData['username'], password: jsonData['password']);
  }

  static Map<String, dynamic> toMap(User user) => {
        'username': user.username,
        'password': user.password,
      };

  static String encode(List<User> users) => json.encode(
        users.map<Map<String, dynamic>>((user) => User.toMap(user)).toList(),
      );

  static List<User> decode(List<dynamic> users) =>
      users.map<User>((item) => User.fromJson(item)).toList();
}
