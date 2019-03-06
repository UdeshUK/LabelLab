class Classification {
  String id;
  String path;
  int size;
  String classifiedBy;
  String timestamp;

  Classification(
      this.id, this.path, this.size, this.classifiedBy, this.timestamp);

  Classification.fromJson(Map<String, dynamic> json) {
    this.id = json["_id"];
    this.path = json["path"];
    this.size = json["size"];
    this.classifiedBy = json["classifiedBy"];
    this.timestamp = json["timestamp"];
  }
}
