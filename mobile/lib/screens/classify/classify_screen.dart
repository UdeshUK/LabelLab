import 'dart:io';

import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/bloc/bloc_provider.dart';
import 'package:mobile/bloc/bloc_state.dart';
import 'package:mobile/modal/classification.dart';
import 'package:mobile/screens/classify/classify_bloc.dart';
import 'package:mobile/widgets/loading_progress.dart';
import 'package:mobile/widgets/selected_image.dart';

class ClassifyScreen extends StatelessWidget {
  final ClassifyBloc _bloc;
  final File image;

  ClassifyScreen(this.image) : this._bloc = ClassifyBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Classification",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Theme.of(context).canvasColor,
          iconTheme: Theme.of(context).iconTheme,
          elevation: 0,
        ),
        body: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SelectedImage(
                      image: image,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            StreamBuilder(
              stream: _bloc.classifyStream,
              initialData: BlocState<Classification>.empty(),
              builder:
                  (context, AsyncSnapshot<BlocState<Classification>> snapshot) {
                final BlocState<Classification> state = snapshot.data;
                if (state.loading) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: LoadingProgress(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  );
                } else if (state.error != null) {
                  return Column(
                    children: <Widget>[
                      _buildClassifyButton(context,
                          icon: Icons.refresh, label: "Retry"),
                      _buildError(state.error),
                    ],
                  );
                } else if (state.result != null) {
                  return Column(
                    children: <Widget>[
                      _buildClassifyButton(context,
                          icon: Icons.refresh, label: "Reclassify"),
                      _buildResult(state.result),
                    ],
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      _buildClassifyButton(context),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassifyButton(BuildContext context,
      {IconData icon, String label}) {
    return FlatButton.icon(
      icon: Icon(icon != null ? icon : Icons.import_export),
      label: Text(label != null ? label : "Classify"),
      textColor: Theme.of(context).primaryColor,
      onPressed: _classify,
    );
  }

  Widget _buildError(dynamic err) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(0),
        color: Colors.red[800],
        child: ListTile(
          title: Text(
            err is DioError ? err.type == DioErrorType.DEFAULT ? "No Connection" : "Error" : "Unknown error",
            style: TextStyle(color: Colors.white),
          ),
          dense: true,
        ),
      ),
    );
  }

  Widget _buildResult(Classification result) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Width"),
              subtitle: Text(result.width.toString() + " px"),
              dense: true,
            ),
            ListTile(
              title: Text("Height"),
              subtitle: Text(result.height.toString() + " px"),
              dense: true,
            ),
            ListTile(
              title: Text("Type"),
              subtitle: Text(result.type),
              dense: true,
            ),
            ListTile(
              title: Text("Classified on"),
              subtitle:
                  Text(DateFormat('yyyy-MM-dd kk:mm').format(result.timestamp)),
              dense: true,
            ),
          ],
        ),
      ),
    );
  }

  void _classify() {
    _bloc.classifyImage(image);
  }
}
