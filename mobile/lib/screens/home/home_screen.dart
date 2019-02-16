import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/screens/classify/classify_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, _) {
        return <Widget>[
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
                          _builtCameraButton(),
                          SizedBox(height: 16),
                          _buildGalleryButton(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pinned: true,
          ),
        ];
      },
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: ListTile(
                title: Text("History"),
                subtitle: Text("Most recent classifications"),
              ),
            )
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

  Widget _builtCameraButton() {
    return Card(
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
          _showImagePicker(ImageSource.camera);
        },
      ),
    );
  }

  Widget _buildGalleryButton() {
    return FloatingActionButton(
      child: Icon(
        Icons.photo_library,
        color: Theme.of(context).primaryColor,
      ),
      mini: true,
      backgroundColor: Colors.white,
      elevation: 1,
      onPressed: () => _showImagePicker(ImageSource.gallery),
    );
  }

  void _showImagePicker(ImageSource source) {
    ImagePicker.pickImage(source: source).then((image) {
      if (image != null)
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ClassifyScreen(image)));
    }).catchError((err) => print(err));
  }
}
