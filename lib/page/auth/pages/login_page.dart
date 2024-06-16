import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:ielts_practice_flutter_application/page/auth/pages/signup_page.dart';
import 'package:ielts_practice_flutter_application/page/layout/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Bộ điều khiển cho các trường nhập liệu username và password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Biến để kiểm soát hiển thị mật khẩu
  bool _passwordObscure = true;

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
                RichText(
                  text: TextSpan(
                    text: "Hello",
                    children: [
                      TextSpan(
                        text: "\nAgain!",
                        style: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: kTitleActiveColor,
                    ),
                  ),
                ),
                const Gap(4),
                Text(
                  "Welcome back you’ve\nbeen missed",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: kBodyTextColor,
                  ),
                ),
                const Gap(48),

                // Nhãn cho trường nhập liệu username
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
                  // Trường nhập liệu username
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

                // Nhãn cho trường nhập liệu password
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

                // Trường nhập liệu password
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
                const Gap(10),

                // Nút quên mật khẩu
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: const Text(
                        "Forgot the password ?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(18),

                // Nút đăng nhập
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    //một button kiểu iOS.
                    color: kPrimaryColor,
                    // đặt màu nền của nút.
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    //thêm khoảng đệm dọc là 13

                    //Xử lý sự kiện khi nhấn nút
                    onPressed: () async {
                      String username = _usernameController.value.text
                          .trim(); //ấy và loại bỏ khoảng trắng đầu và cuối
                      String password = _passwordController.value.text.trim();
                      if (username.isEmpty || password.isEmpty) {
                        _showFailureDialog(
                            context); //Kiểm tra nếu rỗng thì hiển thị hộp thoại thất bại
                      } else {
                        //Lấy instance của SharedPreferences.
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        //Lấy danh sách người dùng từ SharedPreferences và chuyển đổi từ JSON sang danh sách.
                        List<dynamic> data = jsonDecode(
                            prefs.getString("users") == null
                                ? "[]"
                                : prefs.getString("users").toString());

                        //giải mã ds json thành user
                        List<User> users = User.decode(data);
                        bool check = false;
                        for (var e in users) {
                          //kiểm tra từng người dùng trong danh sách
                          if (e.username == username &&
                              e.password == password) {
                            Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => HomePage(),
                            ));
                            check = true;
                            break;
                          }
                        }
                        if (check == false) {
                          _showFailureDialog(context);
                        }
                      }
                    },
                    child: Text(
                      "Login",
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

                // Nút đăng ký tài khoản mới
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "don’t have an account ? ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kBodyTextColor,
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const SignupPage(),
                        ));
                      },
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      child: const Text(
                        "Sign Up",
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

  // Hàm hiển thị thông báo lỗi đăng nhập
  void _showFailureDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Login failure'),
        content: const Text('Please check inputs field!'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// Tham số này cho biết hành động sẽ thực hiện
            /// một hành động phá hoại như xóa và chuyển
            /// màu văn bản của hành động thành màu đỏ.

            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
