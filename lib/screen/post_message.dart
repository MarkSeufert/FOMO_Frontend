import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:group_button/group_button.dart';
import '../globals.dart' as globals;
import '../model/message.dart';
import '../util/map_util.dart';
import '../networking/map_api.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/message.dart';

class PostMessagePage extends StatefulWidget {
  @override
  State<PostMessagePage> createState() => PostMessagePageState();
}

class PostMessagePageState extends State<PostMessagePage> {
  File _image;
  final imagePicker = ImagePicker();
  double _maxImagHeight = 500;
  double _maxImageWidth = 500;

  // double _attachedImagHeight = 100;
  // double _attachedImagWidth = 100;

  String body = '';
  String selectedMessageType = 'regular';

  @override
  void initState() {
    super.initState();
  }

  Future _getImage(ImageSource src) async {
    final pickedFile = await imagePicker.getImage(
        source: src, maxHeight: _maxImagHeight, maxWidth: _maxImageWidth);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Message"),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Text("type"),
                    ),
                    Container(
                      child: GroupButton(
                        isRadio: true,
                        spacing: 10,
                        onSelected: (index, isSelected) => setState(() {
                          selectedMessageType = MessageTypes[index];
                        }),
                        buttons: MessageTypes,
                        selectedColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: _image == null
                          ? Text('No image selected')
                          : Image.file(
                              _image,
                            ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: () async {
                                await _getImage(ImageSource.camera);
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const Icon(Icons.photo),
                              onPressed: () async {
                                await _getImage(ImageSource.gallery);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                maxLength: 250,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (String value) async {
                  await _postMessageDialog(context);
                },
                onChanged: (value) {
                  setState(() {
                    body = value;
                  });
                },
              ),
              Container(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      onPressed: () async {
                        await _postMessageDialog(context);
                      },
                      child: Text("Post"))),
            ])));
  }

  _postMessageDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Post Message'),
          content: Text('Are you sure you want to add this message? "$body".'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _addMessage();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _addMessage() async {
    Position currentPosition = await MapUtils.determineCurrentPosition();
    final Message message = Message(
      user: globals.user,
      type: selectedMessageType,
      body: body,
      position: LatLng(currentPosition.latitude, currentPosition.longitude),
      imageFile: _image,
    );
    if (_image != null) {
      await MapAPI.postMessageWithImage(message);
    } else {
      await MapAPI.postMessage(message);
    }
  }
}
