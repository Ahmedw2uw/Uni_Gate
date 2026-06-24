import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_cubit.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_state.dart';
import 'package:nuigate/features/auth/presentation/widgets/auth_background.dart';
import 'package:nuigate/features/auth/presentation/widgets/login_form_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    _emailController.text = 'mohamed.alaa@dtu.edu.eg';
    _passwordController.text = 'Student@123';
    _nationalIdController.text = '12345678903539';
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: _onAuthStateChanged,
      child: AuthBackground(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return LoginFormCard(
              emailController: _emailController,
              passwordController: _passwordController,
              nationalIdController: _nationalIdController,
              obscurePassword: _obscure,
              isLoading: state is AuthLoading,
              onTogglePassword: _togglePasswordVisibility,
              onSubmit: () => _handleLogin(context),
              onForgotPassword: () {},
            );
          },
        ),
      ),
    );
  }

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم تسجيل الدخول بنجاح')));
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } else if (state is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() => _obscure = !_obscure);
  }

  void _handleLogin(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final nationalId = _nationalIdController.text.trim();

    if (email.isEmpty || password.isEmpty || nationalId.isEmpty) {
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

    context.read<AuthCubit>().login(
      email: email,
      password: password,
      nationalId: nationalId,
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
