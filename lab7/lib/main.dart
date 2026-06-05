import 'package:flutter/material.dart';

void main() {
  runApp(const SignupFormApp());
}

// App chính của Lab 7
class SignupFormApp extends StatelessWidget {
  const SignupFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Signup Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const SignupScreen(),
    );
  }
}

// Màn hình đăng ký tài khoản
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // GlobalKey dùng để quản lý trạng thái của Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controller dùng để lấy dữ liệu trong TextFormField
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // FocusNode dùng để điều khiển focus giữa các ô nhập
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isCheckingEmail = false;
  bool isTermsAccepted = false;
  bool showTermsError = false;

  String savedName = '';
  String savedEmail = '';

  @override
  void dispose() {
    // Hủy controller và focus node để tránh rò rỉ bộ nhớ
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();

    super.dispose();
  }

  // Validate Full Name
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  // Validate Email
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    // Yêu cầu lab: email tối thiểu phải có @ và .
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email';
    }

    return null;
  }

  // Validate Password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }

    return null;
  }

  // Validate Confirm Password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Tính mức độ mạnh của mật khẩu
  String getPasswordStrength(String password) {
    if (password.isEmpty) {
      return 'Empty';
    }

    final hasMinLength = password.length >= 8;
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasSpecialChar = RegExp(
      r'[!@#\$%^&*(),.?":{}|<>]',
    ).hasMatch(password);

    int score = 0;

    if (hasMinLength) score++;
    if (hasDigit) score++;
    if (hasUpperCase) score++;
    if (hasSpecialChar) score++;

    if (score <= 1) {
      return 'Weak';
    } else if (score <= 3) {
      return 'Medium';
    } else {
      return 'Strong';
    }
  }

  Color getStrengthColor(String strength) {
    if (strength == 'Strong') {
      return Colors.green;
    } else if (strength == 'Medium') {
      return Colors.orange;
    } else if (strength == 'Weak') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  // Hàm submit form
  Future<void> submitForm() async {
    // Ẩn bàn phím khi bấm Submit
    FocusScope.of(context).unfocus();

    final bool isValid = formKey.currentState!.validate();

    // Kiểm tra Terms & Conditions
    if (!isTermsAccepted) {
      setState(() {
        showTermsError = true;
      });
    } else {
      setState(() {
        showTermsError = false;
      });
    }

    // Nếu form sai hoặc chưa đồng ý điều khoản thì không submit
    if (!isValid || !isTermsAccepted) {
      return;
    }

    // Lưu dữ liệu sau khi validate thành công
    formKey.currentState!.save();

    setState(() {
      isCheckingEmail = true;
    });

    // Giả lập gọi API kiểm tra email trong 2 giây
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final email = emailController.text.trim().toLowerCase();

    // Quy tắc giả lập: email bắt đầu bằng "taken" thì coi như đã tồn tại
    if (email.startsWith('taken')) {
      setState(() {
        isCheckingEmail = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This email is already taken'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() {
      isCheckingEmail = false;
    });

    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signup successful! Welcome, $savedName'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String strength = getPasswordStrength(passwordController.text);

    return GestureDetector(
      // Bấm ra ngoài form để ẩn bàn phím
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
        appBar: AppBar(title: const Text('Signup'), centerTitle: true),

        body: SafeArea(
          child: Form(
            key: formKey,

            // Tự động validate sau khi người dùng bắt đầu nhập
            autovalidateMode: AutovalidateMode.onUserInteraction,

            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Please fill in the form below to create your account.',
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 24),

                // Full Name Field
                TextFormField(
                  controller: nameController,
                  focusNode: nameFocus,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: validateName,
                  onSaved: (value) {
                    savedName = value!.trim();
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(emailFocus);
                  },
                ),

                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: emailController,
                  focusNode: emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@email.com',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: validateEmail,
                  onSaved: (value) {
                    savedEmail = value!.trim();
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(passwordFocus);
                  },
                ),

                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocus,
                  obscureText: obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'At least 8 characters and 1 digit',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),

                    // Nút hiện / ẩn password
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: validatePassword,
                  onChanged: (value) {
                    setState(() {});
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(confirmPasswordFocus);
                  },
                ),

                const SizedBox(height: 8),

                // Password Strength Indicator
                Row(
                  children: [
                    const Text(
                      'Password strength: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      strength,
                      style: TextStyle(
                        color: getStrengthColor(strength),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocus,
                  obscureText: obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),

                    // Nút hiện / ẩn confirm password
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: validateConfirmPassword,
                  onFieldSubmitted: (_) {
                    submitForm();
                  },
                ),

                const SizedBox(height: 16),

                // Terms & Conditions checkbox
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('I agree to the Terms & Conditions'),
                  value: isTermsAccepted,
                  onChanged: (value) {
                    setState(() {
                      isTermsAccepted = value ?? false;
                      showTermsError = false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                if (showTermsError)
                  const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      'You must accept the Terms & Conditions',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isCheckingEmail ? null : submitForm,
                    child: isCheckingEmail
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Tip: Try an email starting with "taken" to test async validation.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
