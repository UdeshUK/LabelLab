class Classification {
  String id;
  String path;
  int width;
  int height;
  String type;
  String classifiedBy;
  DateTime timestamp;

  Classification(
      this.id, this.path, this.width, this.height, this.type, this.classifiedBy, this.timestamp);

  Classification.fromJson(Map<String, dynamic> json) {
    this.id = json["_id"];
    this.path = json["path"];
    this.width = json["width"];
    this.height = json["height"];
    this.type = json["type"];
    this.classifiedBy = json["classifiedBy"];
    this.timestamp = DateTime.parse(json["timestamp"]);
  }
}
