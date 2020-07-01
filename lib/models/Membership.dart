class Membership {
  static String leaderType = 'leader';
  static String normalType = 'member';

  final String membershipId;
  final String groupName;
  final String username;
  final String dateCreated;
  final String memberType;

  Membership({this.membershipId, this.groupName, this.username, this.dateCreated, this.memberType});

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      membershipId: json['membershipId'],
      groupName: json['groupName'],
      username: json['username'],
      dateCreated: json['dateCreated'],
      memberType: json['memberType']
    );
  }
}
