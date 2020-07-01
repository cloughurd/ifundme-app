import 'package:flutter/material.dart';
import 'package:i_fund_me/Server.dart';
import 'package:i_fund_me/models/Membership.dart';

class NewGroupDialog extends StatefulWidget {
  final String username;
  NewGroupDialog(this.username);
  @override
  _NewGroupDialogState createState() => _NewGroupDialogState(this.username);
}

class _NewGroupDialogState extends State<NewGroupDialog> {
  final Server server = Server.instance();
  String username;
  String _groupName;
  bool _groupNameTaken = false;
  _NewGroupDialogState(this.username);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Group'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _groupNameTaken ? Text('Group Name Unavailable, Try Another') : Text('Enter New Group Name'),
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
          onPressed: () => createGroup(),
        )
      ],
    );
  }

  createGroup() async{
    try {
      await server.createGroup(_groupName);
      await server.createMembership(username, _groupName, Membership.leaderType);
      Navigator.of(context).pop();
    } catch (error) {
      if (error is InternalServerException && error.code == 400) {
        setState(() {
          _groupNameTaken = true;
        });
      } else {
        throw error;
      }
    }
  }
}
