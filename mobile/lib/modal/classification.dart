class Classification {
  String id;
  String path;
  int size;
  String classifiedBy;
  DateTime timestamp;

  Classification(
      this.id, this.path, this.size, this.classifiedBy, this.timestamp);

  Classification.fromJson(Map<String, dynamic> json) {
    this.id = json["_id"];
    this.path = json["path"];
    this.size = int.parse(json["size"]);
    this.classifiedBy = json["classifiedBy"];
    this.timestamp = DateTime.parse(json["timestamp"]);
  }
}
