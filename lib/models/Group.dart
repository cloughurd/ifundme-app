class Group {
  String groupName;
  Group({this.groupName});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupName: json['groupName'],
    );
  }
}