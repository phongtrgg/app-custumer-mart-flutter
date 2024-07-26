class DeviceModelModel {
  String? imageUrl;
  int? regionID;
  String? regionName;
  String? regionCode;

  DeviceModelModel({
    this.imageUrl,
    this.regionID,
    this.regionName,
    this.regionCode,
  });

  DeviceModelModel.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image'];
    regionID = json['id'];
    regionName = json['name'];
    regionCode = json['CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = imageUrl;
    data['id'] = regionID;
    data['name'] = regionName;
    data['CODE'] = regionCode;
    return data;
  }
}
