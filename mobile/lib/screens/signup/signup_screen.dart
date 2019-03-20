import 'package:flutter/material.dart';
import 'package:mobile/bloc/bloc_provider.dart';
import 'package:mobile/bloc/bloc_state.dart';
import 'package:mobile/modal/user.dart';
import 'package:mobile/screens/signup/signup_bloc.dart';
import 'package:mobile/widgets/loading_progress.dart';
import 'package:mobile/widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  SignupBloc _bloc;
  User _data = new User();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _bloc = new SignupBloc();
    _bloc.signupSuccessStream.listen((res) {
      print("Listen success");
      Navigator.pop(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sign Up",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Theme.of(context).canvasColor,
          iconTheme: Theme.of(context).iconTheme,
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    LabelTextField(
                      hintText: 'Username',
                      labelText: 'Enter your username',
                      validator: this._validateUsername,
                      onSaved: (String value) {
                        this._data.username = value;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    LabelTextField(
                      hintText: 'Name',
                      labelText: 'Enter your name',
                      textCapitalization: TextCapitalization.words,
                      validator: this._validateUsername,
                      onSaved: (String value) {
                        this._data.name = value;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    LabelTextField(
                      hintText: 'you@example.com',
                      labelText: 'E-mail Address',
                      keyboardType: TextInputType.emailAddress,
                      validator: this._validateEmail,
                      onSaved: (String value) {
                        this._data.email = value;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    LabelTextField(
                      hintText: 'Password',
                      labelText: 'Enter your password',
                      isObscure: true,
                      validator: this._validatePassword,
                      onSaved: (String value) {
                        this._data.password = value;
                      },
                    ),
                    StreamBuilder(
                      stream: _bloc.signupStream,
                      initialData: BlocState<bool>.empty(),
                      builder:
                          (context, AsyncSnapshot<BlocState<bool>> snapshot) {
                        final BlocState<bool> state = snapshot.data;
                        if (state.loading) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: LoadingProgress(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          );
                        } else if (state.error != null) {
                          return Column(
                            children: <Widget>[
                              _buildSignupButton(context),
                              _buildError(state.error)
                            ],
                          );
                        } else {
                          return _buildSignupButton(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                'Sign Up',
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(color: Colors.white),
              ),
              onPressed: this.submit,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(error) {
    return Text(error.toString());
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email can\'t be empty.';
    }

    return null;
  }

  String _validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username can\'t be empty.';
    }

    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password can\'t be empty.';
    }

    return null;
  }

  void submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      _bloc.signup(this._data);
    }
  }
}
