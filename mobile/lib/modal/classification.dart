class Classification {
  int height;
  int width;
  String type;
  String imageUrl;
  // Removed in the new API
  // int size;

  Classification(this.height, this.width, this.type, this.imageUrl);

  Classification.fromJson(Map<String, dynamic> json) {
    this.height = json["height"];
    this.width = json["width"];
    this.type = json["type"];
    this.imageUrl = json["image_url"];
    // Removed in the new API
    // this.size = json["size"];
  }
}