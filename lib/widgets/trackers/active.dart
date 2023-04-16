import 'package:flutter/material.dart';
import 'package:tracker/services/extension.dart';
import 'package:url_launcher/url_launcher.dart';

class Active extends StatelessWidget {
  String name;
  Widget deleteButton;
  bool delete;
  String color;
  String backgroundColor;
  String content = '';
  bool usePopup = false;

  Active({
    super.key,
    required this.name,
    required this.deleteButton,
    this.delete = false,
    this.color = "#000000",
    this.backgroundColor = "#000000",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        deleteButton,
        Container(
          margin: EdgeInsets.fromLTRB(7, 5, 10, (delete ? 17 : 10)),
          child: Draggable<List<String>>(
            data: [name, color, backgroundColor],
            feedback: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 25,
              child: Center(child: Text(name)),
            ),
            child: CircleAvatar(
              backgroundColor: backgroundColor.toColor(),
              radius: 25,
              child: InkWell(
                onTap: () async {
                  if (usePopup) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(name),
                          content: Text(content),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Uri uri = Uri.parse(content);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      throw 'Could not launch $content';
                    }
                  }
                },
                child: CircleAvatar(
                  backgroundColor: color.toColor(),
                  radius: 22.5,
                  child: Center(child: Text(name)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
