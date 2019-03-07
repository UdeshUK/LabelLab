import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/bloc/bloc_provider.dart';
import 'package:mobile/modal/classification.dart';
import 'package:mobile/screens/classify/classify_screen.dart';
import 'package:mobile/screens/home/history_sliver_delegate.dart';
import 'package:mobile/screens/home/home_bloc.dart';
import 'package:mobile/screens/login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final HomeBloc _bloc;

  HomeScreen() : _bloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 2,
              forceElevated: true,
              centerTitle: true,
              title: Text(
                'LabelLab',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    _bloc.logout().then((_) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    });
                  },
                )
              ],
              backgroundColor: Colors.blue[400],
              expandedHeight: 420.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    _buildToolbarBackground(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 48,
                            ),
                            Text(
                              "Choose an image to classify",
                              style: TextStyle(color: Colors.white, shadows: [
                                Shadow(
                                    color: Colors.black54,
                                    offset: Offset(0.3, 0.8),
                                    blurRadius: 1.5)
                              ]),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _builtCameraButton(context),
                            SizedBox(height: 16),
                            _buildGalleryButton(context),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pinned: true,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: HistorySliverDelegate(
                minHeight: 72.0,
                maxHeight: 72.0,
                child: Card(
                  margin: EdgeInsets.all(0),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  child: ListTile(
                    title: Text("History"),
                    subtitle: Text("Most recent classifications"),
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: _bloc.history(),
              builder: (context, AsyncSnapshot<List<Classification>> snapshot) {
                if (snapshot.hasData) {
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      snapshot.data.map((classification) {
                        double kBytes = classification.size / (1024.0);
                        return Card(
                          margin: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          child: ListTile(
                            title: Text(kBytes.toStringAsFixed(2) + " kB"),
                            subtitle: Text(DateFormat('yyyy-MM-dd kk:mm')
                                .format(classification.timestamp)),
                            dense: true,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      Card(
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        child: ListTile(
                          title: Text("Nothing here"),
                          dense: true,
                        ),
                      )
                    ]),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarBackground() {
    return Opacity(
      opacity: 0.8,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.1, 0.9],
            colors: [
              Colors.blue[800],
              Colors.blue[400],
            ],
          ),
        ),
      ),
    );
  }

  Widget _builtCameraButton(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: CircleBorder(),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Icon(
            Icons.camera_alt,
            size: 56,
            color: Theme.of(context).primaryColor,
          ),
        ),
        onTap: () {
          _showImagePicker(context, ImageSource.camera);
        },
      ),
    );
  }

  Widget _buildGalleryButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.photo_library,
        color: Theme.of(context).primaryColor,
      ),
      mini: true,
      backgroundColor: Colors.white,
      elevation: 1,
      onPressed: () => _showImagePicker(context, ImageSource.gallery),
    );
  }

  void _showImagePicker(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source).then((image) {
      if (image != null)
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ClassifyScreen(image)));
    }).catchError((err) => print(err));
  }
}
