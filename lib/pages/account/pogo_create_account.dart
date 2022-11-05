// Flutter
import 'package:flutter/material.dart';

// Package Imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

// Local
import '../../modules/ui/sizing.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../tools/lowercase_text_formatter.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class PogoCreateAccount extends StatefulWidget {
  const PogoCreateAccount({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  final String email;
  final String password;

  @override
  _PogoCreateAccountState createState() => _PogoCreateAccountState();
}

class _PogoCreateAccountState extends State<PogoCreateAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passwordHidden = true;
  bool _passwordValid = false;

  String? message;

  void _createAccount() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (credential.user != null) {
        Navigator.pop(context);
      } else {
        message = 'An unexpected error occured: failed to create an account :(';
      }
    } catch (e) {
      if (e.runtimeType == FirebaseAuthException) {
        final FirebaseAuthException authException = e as FirebaseAuthException;
        message = authException.message ?? authException.code;
      }
    }

    if (message != null) _showSnackbar(message!);
  }

  Widget _buildPasswordTextField(
    String labelText,
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: labelText,
        suffixIcon: IconButton(
          icon: Icon(
            _passwordHidden ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _passwordHidden = !_passwordHidden;
            });
          },
        ),
      ),
      validator: validator,
      obscureText: _passwordHidden,
    );
  }

  // Build the app bar with the current page title, and icon
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Create Account',
            style: Theme.of(context).textTheme.headline5?.apply(
                  fontStyle: FontStyle.italic,
                ),
          ),

          // Spacer
          SizedBox(
            width: Sizing.blockSizeHorizontal * 2.0,
          ),

          // Page icon
          Icon(
            Icons.account_circle,
            size: Sizing.icon3,
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 15),
      ),
    );
  }

  @override
  void initState() {
    _emailController.text = widget.email;
    _passwordController.text = widget.password;

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
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: Sizing.blockSizeHorizontal * 4.0,
          left: Sizing.blockSizeHorizontal * 2.0,
          right: Sizing.blockSizeHorizontal * 2.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Email password form
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: 'Email',
                    ),
                    validator: (String? value) {
                      if (value == null || !EmailValidator.validate(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    inputFormatters: [LowercaseTextFormatter()],
                  ),
                  Container(
                    height: Sizing.blockSizeVertical * 2,
                  ),
                  _buildPasswordTextField(
                    'Password',
                    _passwordController,
                    (String? value) {
                      if (value == null || value.length < 6) {
                        _passwordValid = false;
                        return 'Password must be at least 6 characters';
                      }
                      _passwordValid = true;
                      return null;
                    },
                  ),
                  Container(
                    height: Sizing.blockSizeVertical * 2,
                  ),
                  _buildPasswordTextField(
                    'Confirm Password',
                    _confirmPasswordController,
                    (String? value) {
                      if (_passwordValid && value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: Sizing.blockSizeVertical * 2,
                  ),
                  GradientButton(
                    onPressed: _createAccount,
                    child: const Text('Create Account'),
                    width: Sizing.screenWidth,
                    height: Sizing.blockSizeVertical * 6,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
