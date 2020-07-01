import 'package:flutter/material.dart';
import 'package:i_fund_me/Server.dart';
import 'package:i_fund_me/models/Membership.dart';

class JoinGroupDialog extends StatefulWidget {
  final String username;
  JoinGroupDialog(this.username);
  @override
  _JoinGroupDialogState createState() => _JoinGroupDialogState(this.username);
}

class _JoinGroupDialogState extends State<JoinGroupDialog> {
  final Server server = Server.instance();
  String username;
  String _groupName;
  bool _invalidGroup = false;
  _JoinGroupDialogState(this.username);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Join Group'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _invalidGroup ? Text('Invalid Group Name, Try Another') : Text('Enter Group Name'),
            TextFormField(
              controller: TextEditingController(text: _groupName),
              onChanged: (String value) {
                _groupName = value;
              },
            )
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text('Submit'),
          onPressed: () => joinGroup(),
        )
      ],
    );
  }

  joinGroup() async{
    try {
      await server.createMembership(
          username, _groupName, Membership.normalType);
      Navigator.of(context).pop();
    } catch (error) {
      if (error is InternalServerException && error.code == 404) {
        setState(() {
          _invalidGroup = true;
        });
      } else {
        throw error;
      }
    }
  }
}
