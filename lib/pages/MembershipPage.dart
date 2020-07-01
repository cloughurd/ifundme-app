import 'package:flutter/material.dart';
import 'package:i_fund_me/Server.dart';
import 'package:i_fund_me/widgets/JoinGroupDialog.dart';
import 'package:i_fund_me/widgets/NewGroupDialog.dart';

class MembershipPage extends StatefulWidget {
  final String username;
  MembershipPage(this.username);
  @override
  _MembershipPageState createState() => _MembershipPageState(this.username);
}

class _MembershipPageState extends State<MembershipPage> {
  final Server server = Server.instance();
  String username;
  Future membershipsFuture;
  _MembershipPageState(this.username){
    membershipsFuture = server.getMembershipsByUser(this.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Select Group')
      ),
      body: Column(
        children: <Widget> [
          Expanded(
            child: FutureBuilder(
              future: membershipsFuture,
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
                    children: snapshot.data.map<Widget>((membership) {
                      return ListTile(
                        title: Text(membership.groupName),
                        trailing: Text(membership.memberType),
                      );
                    }).toList(),
                  );
                }
                else {
                  return ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text('Loading Groups...'),
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text('Join Group'),
                onPressed: () => showJoinGroupDialog(context),
              ),
              RaisedButton(
                child: Text('New Group'),
                onPressed: () => showNewGroupDialog(context),
              ),
            ],
          )
        ]
      )
    );
  }

  showJoinGroupDialog(BuildContext context) async {
    await showDialog(context: context, builder: (context) {
      return JoinGroupDialog(this.username);
    });
    setState(() {
      membershipsFuture = server.getMembershipsByUser(this.username);
    });
  }

  showNewGroupDialog(BuildContext context) async {
    await showDialog(context: context, builder: (context) {
      return NewGroupDialog(this.username);
    });
    setState(() {
      membershipsFuture = server.getMembershipsByUser(this.username);
    });
  }
}

