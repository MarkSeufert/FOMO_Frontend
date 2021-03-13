import 'package:flutter/material.dart';
import 'map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../model/message.dart';
import '../util/map_util.dart';
import 'package:group_button/group_button.dart';
import '../globals.dart' as globals;

class PostMessagePage extends StatefulWidget {
  @override
  State<PostMessagePage> createState() => PostMessagePageState();
}

class PostMessagePageState extends State<PostMessagePage> {
  static int _messageCounter = MapScreenState
      .messageList.length; // Will be removed once api calls implemented
  List<String> messageTypes = [];

  String body = '';
  MessageType selectedMessageType = MessageType.regular;

  @override
  void initState() {
    for (MessageType value in MessageType.values) {
      messageTypes.add(value.toString().split('.').last);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Message"),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("type: "),
                        Center(
                            child: GroupButton(
                          isRadio: true,
                          spacing: 10,
                          onSelected: (index, isSelected) => setState(() {
                            selectedMessageType = MessageType.values[index];
                          }),
                          buttons: messageTypes,
                          selectedColor: Colors.blue,
                        )),
                      ])),
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
      messageId: _messageCounter,
      user: globals.user,
      type: selectedMessageType,
      body: body,
      position: LatLng(currentPosition.latitude, currentPosition.longitude),
      alpha: 1,
      visible: true,
    );
    _messageCounter++;
    MapScreenState.messageList.add(message);
  }
}
