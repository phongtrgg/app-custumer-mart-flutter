class CountryModel {
  dynamic? imageUrl;
  int? regionID;
  String? regionName;
  String? regionCode;

  CountryModel({
    this.imageUrl,
    this.regionID,
    this.regionName,
    this.regionCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      regionID: json['id'],
      regionName: json['name'],
      regionCode: json['CODE'],
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': regionID,
      'name': regionName,
      'CODE': regionCode,
      'image': imageUrl,
    };
  }
}
