import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';
import '../presentation/cubit/auth_cubit.dart';
import '../presentation/cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    _emailController.text = "mohamed.alaa@dtu.edu.eg";
    _passwordController.text = "Student@123";
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // التنقل إلى الداشبورد عند نجاح تسجيل الدخول
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
          );
        } else if (state is AuthFailure) {
          // عرض رسالة الخطأ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            /// background image
            Positioned.fill(
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(
                  "assets/ground.png",
                  color: AppColors.primary,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// الصفحة
            Directionality(
              textDirection: TextDirection.rtl,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width > 600 ? 420 : width,
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 28,
                        ),
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                /// logo
                                Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: ImageIcon(
                                          const AssetImage('assets/p_icon.png'),
                                          size: 48,
                                          color: AppColors.primary,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      const CustomText(
                                        'بوابة الطالب',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),

                                      const SizedBox(height: 4),

                                      const CustomText(
                                        'تسجيل الدخول',
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// email
                                TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  enabled: state is! AuthLoading,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                    ),
                                    hintText: 'example@email.com',
                                    labelText: 'البريد الإلكتروني',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                /// password
                                TextField(
                                  controller: _passwordController,
                                  obscureText: _obscure,
                                  enabled: state is! AuthLoading,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    labelText: 'كلمة المرور',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: state is AuthLoading
                                          ? null
                                          : () {
                                              setState(() {
                                                _obscure = !_obscure;
                                              });
                                            },
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                /// login button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    disabledBackgroundColor: AppColors.primary
                                        .withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  onPressed: state is AuthLoading
                                      ? null
                                      : () {
                                          _handleLogin(context);
                                        },
                                  child: state is AuthLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const CustomText(
                                          'تسجيل الدخول',
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.center,
                                        ),
                                ),

                                const SizedBox(height: 12),

                                /// forgot password
                                Center(
                                  child: TextButton(
                                    onPressed: state is AuthLoading
                                        ? null
                                        : () {},
                                    child: const CustomText(
                                      'هل نسيت كلمة المرور؟',
                                      color: AppColors.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// معالجة عملية تسجيل الدخول
  void _handleLogin(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // التحقق من صحة البيانات المدخلة
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرجاء ملء جميع الحقول')));
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('البريد الإلكتروني غير صحيح')),
      );
      return;
    }

    // استدعاء الـ login من الـ Cubit
    context.read<AuthCubit>().login(email: email, password: password);
  }

  /// التحقق من صحة البريد الإلكتروني
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
