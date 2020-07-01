import 'package:flutter/material.dart';
import 'package:i_fund_me/Server.dart';

class NewUserDialog extends StatefulWidget {
  @override
  _NewUserDialogState createState() => _NewUserDialogState();
}

class _NewUserDialogState extends State<NewUserDialog> {
  final Server server = Server.instance();
  String _username;
  bool _usernameTaken = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New User'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _usernameTaken ? Text('Username Unavailable, Try Another') : Text('Enter New Username'),
            TextFormField(
              controller: TextEditingController(text: _username),
              onChanged: (String value) {
                _username = value;
              },
            )
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text('Submit'),
          onPressed: () => createUser(),
        )
      ],
    );
  }

  createUser() async{
    try {
      await server.createUser(_username);
      Navigator.of(context).pop();
    } catch (error) {
      if (error is InternalServerException && error.code == 400) {
        setState(() {
          _usernameTaken = true;
        });
      } else {
        throw error;
      }
    }
  }
}