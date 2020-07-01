import 'package:flutter/material.dart';
import 'package:i_fund_me/Server.dart';
import 'package:i_fund_me/models/User.dart';
import 'package:i_fund_me/pages/MembershipPage.dart';
import 'package:i_fund_me/widgets/NewUserDialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future usersFuture;
  final Server server = Server.instance();

  _LoginPageState() {
    usersFuture = server.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select User')
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: usersFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(snapshot.error.toString()),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data.map<Widget>((user) {
                      return ListTile(
                        title: Text(user.username),
                        trailing: Text('Last Login: ' + user.dateLastAccessed),
                        onTap: () => goToGroupListPage(context, user.username),
                      );
                    }).toList(),
                  );
                }
                else {
                  return ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text('Loading Users...'),
                  );
                }
              }
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text('New User'),
                onPressed: () => showNewUserDialog(context),
              )
            ],
          )
        ]
      )
    );
  }

  showNewUserDialog(BuildContext context) async{
    await showDialog(
        context: context,
        builder: (context) {
          return NewUserDialog();
        }
    );
    setState(() {
      usersFuture = server.getUsers();
    });
  }
}

void goToGroupListPage(BuildContext context, String username) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => MembershipPage(username)));
}
