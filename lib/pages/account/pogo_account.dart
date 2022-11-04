// Flutter
import 'package:flutter/material.dart';

// Package Imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pogo_teams/pages/account/pogo_create_account.dart';
import 'package:email_validator/email_validator.dart';

// Local
import '../../modules/ui/sizing.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../tools/lowercase_text_formatter.dart';

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
  bool _passwordHidden = true;
  User? _currentUser;

  bool get _userIsSignedIn {
    return _currentUser != null;
  }

  void _createAccount() async {
    await Navigator.push(
      context,
      MaterialPageRoute<PogoCreateAccount>(builder: (BuildContext context) {
        return PogoCreateAccount(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }),
    );
  }

  void _signInWithEmailAndPassword() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      setState(() => _currentUser = user);
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
    });
  }

  void _resetPassword() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: 'Email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Enter a valid email address';
                }
                return null;
              },
              inputFormatters: [LowercaseTextFormatter()],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.bodyText1,
                ),
                child: const Text('Send Reset Email'),
                onPressed: () {
                  _sendPasswordResetEmail();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(
        email: _emailController.text,
        actionCodeSettings: ActionCodeSettings(
          url: 'https://pogo-teams-host.firebaseapp.com',
          androidPackageName: 'com.pogoteams',
          iOSBundleId: 'com.pogoteams',
        ),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'Password reset email successfully sent to ${_emailController.text}.',
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildSignInWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
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
                height: Sizing.blockSizeVertical * 2,
              ),
              GradientButton(
                onPressed: _signInWithEmailAndPassword,
                child: Text(
                  'Sign In',
                  style: Theme.of(context).textTheme.headline6,
                ),
                width: Sizing.screenWidth,
                height: Sizing.blockSizeVertical * 6,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return Colors.white;
                },
              ),
            ),
            onPressed: _resetPassword,
            child: Text(
              'Reset Password',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        Container(
          height: Sizing.blockSizeVertical * 10,
        ),
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                return Colors.white;
              },
            ),
          ),
          onPressed: _createAccount,
          child: Text(
            'Create Account',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _currentUser?.email != null
            ? Text(
                _currentUser!.email!,
                style: Theme.of(context).textTheme.headline5,
              )
            : Container(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: GradientButton(
            onPressed: _signOut,
            child: const Text('Sign Out'),
            width: Sizing.screenWidth,
            height: Sizing.blockSizeVertical * 6,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.blockSizeHorizontal * 4.0,
        left: Sizing.blockSizeHorizontal * 2.0,
        right: Sizing.blockSizeHorizontal * 2.0,
      ),
      child: _userIsSignedIn ? _buildSignOutWidget() : _buildSignInWidget(),
    );
  }
}
