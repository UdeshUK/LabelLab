class Classification {
  int height;
  int size;

  Classification(this.height, this.size);

  Classification.fromJson(Map<String, dynamic> json) {
    // this.height = json["height"];
    this.size = json["size"];
  }
}