// Package Imports
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pogo_teams/modules/ui/sizing.dart';
import 'package:pogo_teams/widgets/buttons/gradient_button.dart';

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

  void _register() async {
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
  }

  void _signInWithEmailAndPassword() async {
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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Enter a password';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: GradientButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _register();
                }
              },
              child: const Text('Create Account'),
              width: Sizing.screenWidth * .85,
              height: Sizing.blockSizeVertical * 8.5,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: GradientButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _signInWithEmailAndPassword();
                }
              },
              child: const Text('Sign In'),
              width: Sizing.screenWidth * .85,
              height: Sizing.blockSizeVertical * 8.5,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(_success == null
                ? ''
                : _success!
                    ? 'Successfully registered $_userEmail'
                    : 'Registration failed'),
          ),
        ],
      ),
    );
  }
}
