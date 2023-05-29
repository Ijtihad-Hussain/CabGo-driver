import 'package:cab_go_driver/rideRequestsPage.dart';
import 'package:cab_go_driver/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailSignInForm extends StatefulWidget {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isSignInForm = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isSignInForm ? 'Sign In' : 'Sign Up'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address.';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              if (!_isSignInForm)
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name.';
                    }
                    return null;
                  },
                ),
              if (!_isSignInForm)
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number.';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              if (!_isSignInForm)
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password.';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 24.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kYellow),
                ),
                onPressed: _submitForm,
                child: Text(
                  _isSignInForm ? 'Sign In' : 'Sign Up',
                  style: CustomTextStyles.boldStyle,
                ),
              ),
              TextButton(
                onPressed: _toggleFormType,
                child: Text(_isSignInForm
                    ? 'Need an account? Sign up'
                    : 'Have an account? Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        if (_isSignInForm) {
          // Sign in with email and password
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          // Sign up with email and password
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          // Create a document for the user in Firestore
          await FirebaseFirestore.instance
              .collection('drivers')
              .doc(userCredential.user?.uid)
              .set({
            'email': email,
            'userId': userCredential.user?.uid,
            'name': _nameController.text,
            'phone': _phoneNumberController.text,
          });
        }
        print(_phoneNumberController.text);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RideRequestsPage(userName: _nameController.text,)),
        );
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _toggleFormType() {
    setState(() {
      _isSignInForm = !_isSignInForm;
    });
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }
}
