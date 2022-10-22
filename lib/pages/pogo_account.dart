// Flutter
import 'package:flutter/material.dart';

// Package Imports
import 'package:firebase_auth/firebase_auth.dart';

// Local
import '../modules/ui/sizing.dart';
import '../widgets/buttons/gradient_button.dart';
import '../tools/lowercase_text_formatter.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class PogoAccount extends StatefulWidget {
  const PogoAccount({Key? key}) : super(key: key);

  @override
  _PogoAccountState createState() => _PogoAccountState();
}

class _PogoAccountState extends State<PogoAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool? _success;
  String _userEmail = '';
  bool _passwordHidden = true;

  bool get _userIsSignedIn {
    return _auth.currentUser != null;
  }

  void _register() async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email!;
        });
      } else {
        setState(() {
          _success = true;
        });
      }
    } catch (e) {
      if (e.runtimeType == FirebaseAuthException) {
        switch ((e as FirebaseAuthException).code) {
          case 'email-already-in-use':
            break;
          case 'invalid-email':
            break;
          case 'user-not-found':
            break;
          case 'weak-password':
            break;
        }
      }
    }
  }

  void _signInWithEmailAndPassword() async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email!;
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } catch (e) {
      if (e.runtimeType == FirebaseAuthException) {
        switch ((e as FirebaseAuthException).code) {
          case 'invalid-email':
            break;
          case 'user-disabled':
            break;
          case 'user-not-found':
            break;
          case 'wrong-password':
            break;
        }
      }
    }
  }

  void _signOut() async {
    await _auth.signOut();
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _userEmail = '';
    });
  }

  void _resetPassword() async {
    try {
      /* TODO password reset
      _auth.sendPasswordResetEmail(
        email: _emailController.text,
        actionCodeSettings: ActionCodeSettings(
          url: 'https://pogo-teams-host.firebaseapp.com',
          androidPackageName: 'com.pogoteams',
          iOSBundleId: 'com.pogoteams',
        ),
      );
      */
    } catch (e) {
      if (e.runtimeType == FirebaseAuthException) {
        switch ((e as FirebaseAuthException).code) {
          case 'auth/invalid-email':
            break;
          case 'auth/user-not-found':
            break;
        }
      }
    }
  }

  Widget _buildEmailPasswordWidget() {
    if (_userIsSignedIn) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        alignment: Alignment.center,
        child: GradientButton(
          onPressed: _signOut,
          child: const Text('Sign Out'),
          width: Sizing.screenWidth * .85,
          height: Sizing.blockSizeVertical * 8.5,
        ),
      );
    }
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Enter a valid email address';
              }
              return null;
            },
            inputFormatters: [LowercaseTextFormatter()],
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
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
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Enter a password';
              }
              return null;
            },
            obscureText: _passwordHidden,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GradientButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _signInWithEmailAndPassword();
                    }
                  },
                  child: const Text('Sign In'),
                  width: Sizing.screenWidth * .4,
                  height: Sizing.blockSizeVertical * 4.5,
                ),
                GradientButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _register();
                    }
                  },
                  child: const Text('Create Account'),
                  width: Sizing.screenWidth * .4,
                  height: Sizing.blockSizeVertical * 4.5,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: GradientButton(
              onPressed: _resetPassword,
              child: const Text('Reset Password'),
              width: Sizing.screenWidth * .85,
              height: Sizing.blockSizeVertical * 4.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildEmailPasswordWidget();
  }
}
