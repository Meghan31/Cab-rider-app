class NearbyAvailableDrivers {
  String? key;
  double? latitude;
  double? longitude;

  NearbyAvailableDrivers({this.key, this.latitude, this.longitude});

  NearbyAvailableDrivers.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
