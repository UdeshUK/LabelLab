import 'package:flutter/material.dart';
import 'package:mobile/bloc/bloc_provider.dart';
import 'package:mobile/bloc/bloc_state.dart';
import 'package:mobile/modal/credential.dart';
import 'package:mobile/screens/home/home_screen.dart';
import 'package:mobile/screens/login/login_bloc.dart';
import 'package:mobile/screens/signup/signup_screen.dart';
import 'package:mobile/widgets/loading_progress.dart';
import 'package:mobile/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  LoginBloc _bloc;
  Credential _data = new Credential();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    print("init");
    _bloc = LoginBloc();
    _bloc.loginSilent();
    _bloc.loginSuccessStream.listen((bool res) {
      if (res) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            SizedBox(height: 56),
            Center(
              child: Text('LabelLab', style: Theme.of(context).textTheme.title),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildForm(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: StreamBuilder(
        stream: _bloc.loginStream,
        initialData: BlocState<bool>.empty(),
        builder: (context, AsyncSnapshot<BlocState<bool>> snapshot) {
          final BlocState<bool> state = snapshot.data;
          if (state.loading && state.result != null && !state.result) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: LoadingProgress(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            );
          } else if (state.loading) {
            return Column(
              children: <Widget>[
                _buildLoginForm(context),
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
                _buildLoginForm(context),
                _buildLoginButton(context),
                _buildError(state.error),
                _buildSignupButton(context)
              ],
            );
          } else if (state.result != null && state.result) {
            return Container();
          } else {
            return Column(
              children: <Widget>[
                _buildLoginForm(context),
                _buildLoginButton(context),
                _buildSignupButton(context)
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      children: <Widget>[
        LabelTextField(
          labelText: 'Username',
          hintText: 'Enter your username',
          validator: this._validateUsername,
          onSaved: (String value) {
            this._data.username = value;
          },
        ),
        SizedBox(
          height: 16,
        ),
        LabelTextField(
          labelText: 'Password',
          hintText: 'Enter your password',
          validator: this._validatePassword,
          onSaved: (String value) {
            this._data.password = value;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
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
                'Login',
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

  Widget _buildSignupButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FlatButton(
        child: Text("or Signup"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignupScreen()),
          );
        },
      ),
    );
  }

  Widget _buildError(error) {
    return Text(error.toString());
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

      _bloc.login(this._data);
    }
  }
}
