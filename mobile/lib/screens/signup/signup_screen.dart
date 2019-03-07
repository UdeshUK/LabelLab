import 'package:flutter/material.dart';
import 'package:mobile/bloc/bloc_provider.dart';
import 'package:mobile/bloc/bloc_state.dart';
import 'package:mobile/modal/user.dart';
import 'package:mobile/screens/signup/signup_bloc.dart';
import 'package:mobile/widgets/loading_progress.dart';

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
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 56),
                Center(
                  child: Text('LabelLab',
                      style: Theme.of(context).textTheme.title),
                ),
                SizedBox(height: 24),
                TextFormField(
                  decoration: new InputDecoration(
                      hintText: 'Username', labelText: 'Enter your username'),
                  validator: this._validateUsername,
                  onSaved: (String value) {
                    this._data.username = value;
                  },
                ),
                TextFormField(
                  decoration: new InputDecoration(
                      hintText: 'Name', labelText: 'Enter your name'),
                  validator: this._validateUsername,
                  onSaved: (String value) {
                    this._data.name = value;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType
                      .emailAddress, // Use email input type for emails.
                  decoration: new InputDecoration(
                      hintText: 'you@example.com', labelText: 'E-mail Address'),
                  validator: this._validateEmail,
                  onSaved: (String value) {
                    this._data.email = value;
                  },
                ),
                TextFormField(
                  obscureText: true, // Use secure text for passwords.
                  decoration: new InputDecoration(
                      hintText: 'Password', labelText: 'Enter your password'),
                  validator: this._validatePassword,
                  onSaved: (String value) {
                    this._data.password = value;
                  },
                ),
                StreamBuilder(
                  stream: _bloc.signupStream,
                  initialData: BlocState<bool>.empty(),
                  builder: (context, AsyncSnapshot<BlocState<bool>> snapshot) {
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
        ),
      ),
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return Container(
      child: new RaisedButton(
        child: new Text(
          'Sign Up',
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: this.submit,
        color: Colors.blue,
      ),
      margin: new EdgeInsets.only(top: 20.0),
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
