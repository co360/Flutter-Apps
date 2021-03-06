import 'package:brew_app/shared/constants.dart';
import 'package:brew_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_app/services/auth.dart';

class Register extends StatefulWidget {
  // create a constructor
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  bool loading = false;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  // FormState - State associated with a [Form] widget.
  // A [FormState] object can be used to [save], [reset], and [validate] every [FormField] that is a descendant of the associated [Form].
  final _formkey = GlobalKey<FormState>();

  // Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
                backgroundColor: Colors.brown[400],
                elevation: 0,
                title: Text('Sign up to Brew Crew'),
                actions: [
                  FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text("Sign In"),
                      onPressed: () {
                        widget.toggleView();
                      })
                ]),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                  // Build a Form widget using the _formKey created above.
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email is required';
                          }
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          if (!(regex.hasMatch(value))) {
                            return "Invalid Email";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                        validator: (val) => val.length < 6
                            ? 'Enter a password 6+ characters long'
                            : null,
                        // hide input data e.g password
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.pink[400],
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            // validate() returns true or false based on specified on formField validator
                            if (_formkey.currentState.validate()) {
                              setState(() => loading = !loading);
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password);
                              if (result == null) {
                                setState(
                                    () {
                                      error = 'Please apply a valid email';
                                      loading = !loading;
                                });
                              }
                            }
                          }),
                      SizedBox(height: 12),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      )
                    ],
                  )),
            ),
          );
  }
}
