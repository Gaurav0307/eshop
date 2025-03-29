import 'dart:convert';

/// message : "All Businesses & Services fetched!"
/// businessesServices : [{"location":{"lat":25.253463,"lon":87.021955},"_id":"67de71b8ee66c559110e61ac","name":"The Barber Shop","type":"Business","category":"Barber","openTime":"08:00 AM","closeTime":"08:00 PM","productsServices":["Haircuts & Styling","Beard & Mustache Grooming"],"address":"Zero Mile","country":"India","state":"Bihar","city":"Bhagalpur","mobile":"+919876543210","image":"files\\business_image\\1742631352201-973442428-barber.jpeg","createdBy":{"_id":"67d81eee15ffef18e3b7f33f","fullname":"Gaurav Prasad","mobile":"+919876543210","image":"files\\profile_picture\\1743154548270-887152853-scaled_1000063869.jpg"},"callEnabled":false,"messageEnabled":true,"rating":0,"ratedBy":0,"isActive":true,"deviceId":"","chats":[{"_id":"67dd24f8edd91092e91a6cd6","fullname":"Anand Kumar","mobile":"+919876543211","image":"files\\profile_picture\\1743238161629-224761675-gaurav.jpg"}],"createdAt":"2025-03-22T08:15:52.342Z","updatedAt":"2025-03-29T08:48:54.297Z","__v":16},{"location":{"lat":25.253463,"lon":87.021955},"_id":"67de72f9ee66c559110e61b7","name":"The Barber Shop","type":"Service","category":"Barber","openTime":"08:00 AM","closeTime":"08:00 PM","productsServices":["Haircuts & Styling","Beard & Mustache Grooming"],"address":"Zero Mile","country":"India","state":"Bihar","city":"Bhagalpur","mobile":"+919876543210","image":"files\\business_image\\1742631673590-945720388-barber.jpeg","createdBy":{"_id":"67d81eee15ffef18e3b7f33f","fullname":"Gaurav Prasad","mobile":"+919876543210","image":"files\\profile_picture\\1743154548270-887152853-scaled_1000063869.jpg"},"callEnabled":false,"messageEnabled":false,"rating":0,"ratedBy":0,"isActive":true,"deviceId":"","chats":[],"createdAt":"2025-03-22T08:21:13.721Z","updatedAt":"2025-03-29T08:48:54.297Z","__v":0}]

BusinessServiceModel businessServiceModelFromJson(String str) =>
    BusinessServiceModel.fromJson(json.decode(str));
String businessServiceModelToJson(BusinessServiceModel data) =>
    json.encode(data.toJson());

class BusinessServiceModel {
  BusinessServiceModel({
    String? message,
    List<BusinessesServices>? businessesServices,
  }) {
    _message = message;
    _businessesServices = businessesServices;
  }

  BusinessServiceModel.fromJson(dynamic json) {
    _message = json['message'];
    if (json['businessesServices'] != null) {
      _businessesServices = [];
      json['businessesServices'].forEach((v) {
        _businessesServices?.add(BusinessesServices.fromJson(v));
      });
    }
  }
  String? _message;
  List<BusinessesServices>? _businessesServices;
  BusinessServiceModel copyWith({
    String? message,
    List<BusinessesServices>? businessesServices,
  }) =>
      BusinessServiceModel(
        message: message ?? _message,
        businessesServices: businessesServices ?? _businessesServices,
      );
  String? get message => _message;
  List<BusinessesServices>? get businessesServices => _businessesServices;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    if (_businessesServices != null) {
      map['businessesServices'] =
          _businessesServices?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// location : {"lat":25.253463,"lon":87.021955}
/// _id : "67de71b8ee66c559110e61ac"
/// name : "The Barber Shop"
/// type : "Business"
/// category : "Barber"
/// openTime : "08:00 AM"
/// closeTime : "08:00 PM"
/// productsServices : ["Haircuts & Styling","Beard & Mustache Grooming"]
/// address : "Zero Mile"
/// country : "India"
/// state : "Bihar"
/// city : "Bhagalpur"
/// mobile : "+919876543210"
/// image : "files\\business_image\\1742631352201-973442428-barber.jpeg"
/// createdBy : {"_id":"67d81eee15ffef18e3b7f33f","fullname":"Gaurav Prasad","mobile":"+919876543210","image":"files\\profile_picture\\1743154548270-887152853-scaled_1000063869.jpg"}
/// callEnabled : false
/// messageEnabled : true
/// rating : 0
/// ratedBy : 0
/// isActive : true
/// deviceId : ""
/// chats : [{"_id":"67dd24f8edd91092e91a6cd6","fullname":"Anand Kumar","mobile":"+919876543211","image":"files\\profile_picture\\1743238161629-224761675-gaurav.jpg"}]
/// createdAt : "2025-03-22T08:15:52.342Z"
/// updatedAt : "2025-03-29T08:48:54.297Z"
/// __v : 16

BusinessesServices businessesServicesFromJson(String str) =>
    BusinessesServices.fromJson(json.decode(str));
String businessesServicesToJson(BusinessesServices data) =>
    json.encode(data.toJson());

class BusinessesServices {
  BusinessesServices({
    Location? location,
    String? id,
    String? name,
    String? type,
    String? category,
    String? openTime,
    String? closeTime,
    List<String>? productsServices,
    String? address,
    String? country,
    String? state,
    String? city,
    String? mobile,
    String? image,
    CreatedBy? createdBy,
    bool? callEnabled,
    bool? messageEnabled,
    num? rating,
    num? ratedBy,
    bool? isActive,
    String? deviceId,
    List<Chats>? chats,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    _location = location;
    _id = id;
    _name = name;
    _type = type;
    _category = category;
    _openTime = openTime;
    _closeTime = closeTime;
    _productsServices = productsServices;
    _address = address;
    _country = country;
    _state = state;
    _city = city;
    _mobile = mobile;
    _image = image;
    _createdBy = createdBy;
    _callEnabled = callEnabled;
    _messageEnabled = messageEnabled;
    _rating = rating;
    _ratedBy = ratedBy;
    _isActive = isActive;
    _deviceId = deviceId;
    _chats = chats;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  BusinessesServices.fromJson(dynamic json) {
    _location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    _id = json['_id'];
    _name = json['name'];
    _type = json['type'];
    _category = json['category'];
    _openTime = json['openTime'];
    _closeTime = json['closeTime'];
    _productsServices = json['productsServices'] != null
        ? json['productsServices'].cast<String>()
        : [];
    _address = json['address'];
    _country = json['country'];
    _state = json['state'];
    _city = json['city'];
    _mobile = json['mobile'];
    _image = json['image'];
    _createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
    _callEnabled = json['callEnabled'];
    _messageEnabled = json['messageEnabled'];
    _rating = json['rating'];
    _ratedBy = json['ratedBy'];
    _isActive = json['isActive'];
    _deviceId = json['deviceId'];
    if (json['chats'] != null) {
      _chats = [];
      json['chats'].forEach((v) {
        _chats?.add(Chats.fromJson(v));
      });
    }
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  Location? _location;
  String? _id;
  String? _name;
  String? _type;
  String? _category;
  String? _openTime;
  String? _closeTime;
  List<String>? _productsServices;
  String? _address;
  String? _country;
  String? _state;
  String? _city;
  String? _mobile;
  String? _image;
  CreatedBy? _createdBy;
  bool? _callEnabled;
  bool? _messageEnabled;
  num? _rating;
  num? _ratedBy;
  bool? _isActive;
  String? _deviceId;
  List<Chats>? _chats;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  BusinessesServices copyWith({
    Location? location,
    String? id,
    String? name,
    String? type,
    String? category,
    String? openTime,
    String? closeTime,
    List<String>? productsServices,
    String? address,
    String? country,
    String? state,
    String? city,
    String? mobile,
    String? image,
    CreatedBy? createdBy,
    bool? callEnabled,
    bool? messageEnabled,
    num? rating,
    num? ratedBy,
    bool? isActive,
    String? deviceId,
    List<Chats>? chats,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) =>
      BusinessesServices(
        location: location ?? _location,
        id: id ?? _id,
        name: name ?? _name,
        type: type ?? _type,
        category: category ?? _category,
        openTime: openTime ?? _openTime,
        closeTime: closeTime ?? _closeTime,
        productsServices: productsServices ?? _productsServices,
        address: address ?? _address,
        country: country ?? _country,
        state: state ?? _state,
        city: city ?? _city,
        mobile: mobile ?? _mobile,
        image: image ?? _image,
        createdBy: createdBy ?? _createdBy,
        callEnabled: callEnabled ?? _callEnabled,
        messageEnabled: messageEnabled ?? _messageEnabled,
        rating: rating ?? _rating,
        ratedBy: ratedBy ?? _ratedBy,
        isActive: isActive ?? _isActive,
        deviceId: deviceId ?? _deviceId,
        chats: chats ?? _chats,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
      );
  Location? get location => _location;
  String? get id => _id;
  String? get name => _name;
  String? get type => _type;
  String? get category => _category;
  String? get openTime => _openTime;
  String? get closeTime => _closeTime;
  List<String>? get productsServices => _productsServices;
  String? get address => _address;
  String? get country => _country;
  String? get state => _state;
  String? get city => _city;
  String? get mobile => _mobile;
  String? get image => _image;
  CreatedBy? get createdBy => _createdBy;
  bool? get callEnabled => _callEnabled;
  bool? get messageEnabled => _messageEnabled;
  num? get rating => _rating;
  num? get ratedBy => _ratedBy;
  bool? get isActive => _isActive;
  String? get deviceId => _deviceId;
  List<Chats>? get chats => _chats;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    map['_id'] = _id;
    map['name'] = _name;
    map['type'] = _type;
    map['category'] = _category;
    map['openTime'] = _openTime;
    map['closeTime'] = _closeTime;
    map['productsServices'] = _productsServices;
    map['address'] = _address;
    map['country'] = _country;
    map['state'] = _state;
    map['city'] = _city;
    map['mobile'] = _mobile;
    map['image'] = _image;
    if (_createdBy != null) {
      map['createdBy'] = _createdBy?.toJson();
    }
    map['callEnabled'] = _callEnabled;
    map['messageEnabled'] = _messageEnabled;
    map['rating'] = _rating;
    map['ratedBy'] = _ratedBy;
    map['isActive'] = _isActive;
    map['deviceId'] = _deviceId;
    if (_chats != null) {
      map['chats'] = _chats?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }
}

/// _id : "67dd24f8edd91092e91a6cd6"
/// fullname : "Anand Kumar"
/// mobile : "+919876543211"
/// image : "files\\profile_picture\\1743238161629-224761675-gaurav.jpg"

Chats chatsFromJson(String str) => Chats.fromJson(json.decode(str));
String chatsToJson(Chats data) => json.encode(data.toJson());

class Chats {
  Chats({
    String? id,
    String? fullname,
    String? mobile,
    String? image,
  }) {
    _id = id;
    _fullname = fullname;
    _mobile = mobile;
    _image = image;
  }

  Chats.fromJson(dynamic json) {
    _id = json['_id'];
    _fullname = json['fullname'];
    _mobile = json['mobile'];
    _image = json['image'];
  }
  String? _id;
  String? _fullname;
  String? _mobile;
  String? _image;
  Chats copyWith({
    String? id,
    String? fullname,
    String? mobile,
    String? image,
  }) =>
      Chats(
        id: id ?? _id,
        fullname: fullname ?? _fullname,
        mobile: mobile ?? _mobile,
        image: image ?? _image,
      );
  String? get id => _id;
  String? get fullname => _fullname;
  String? get mobile => _mobile;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['fullname'] = _fullname;
    map['mobile'] = _mobile;
    map['image'] = _image;
    return map;
  }
}

/// _id : "67d81eee15ffef18e3b7f33f"
/// fullname : "Gaurav Prasad"
/// mobile : "+919876543210"
/// image : "files\\profile_picture\\1743154548270-887152853-scaled_1000063869.jpg"

CreatedBy createdByFromJson(String str) => CreatedBy.fromJson(json.decode(str));
String createdByToJson(CreatedBy data) => json.encode(data.toJson());

class CreatedBy {
  CreatedBy({
    String? id,
    String? fullname,
    String? mobile,
    String? image,
  }) {
    _id = id;
    _fullname = fullname;
    _mobile = mobile;
    _image = image;
  }

  CreatedBy.fromJson(dynamic json) {
    _id = json['_id'];
    _fullname = json['fullname'];
    _mobile = json['mobile'];
    _image = json['image'];
  }
  String? _id;
  String? _fullname;
  String? _mobile;
  String? _image;
  CreatedBy copyWith({
    String? id,
    String? fullname,
    String? mobile,
    String? image,
  }) =>
      CreatedBy(
        id: id ?? _id,
        fullname: fullname ?? _fullname,
        mobile: mobile ?? _mobile,
        image: image ?? _image,
      );
  String? get id => _id;
  String? get fullname => _fullname;
  String? get mobile => _mobile;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['fullname'] = _fullname;
    map['mobile'] = _mobile;
    map['image'] = _image;
    return map;
  }
}

/// lat : 25.253463
/// lon : 87.021955

Location locationFromJson(String str) => Location.fromJson(json.decode(str));
String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  Location({
    num? lat,
    num? lon,
  }) {
    _lat = lat;
    _lon = lon;
  }

  Location.fromJson(dynamic json) {
    _lat = json['lat'];
    _lon = json['lon'];
  }
  num? _lat;
  num? _lon;
  Location copyWith({
    num? lat,
    num? lon,
  }) =>
      Location(
        lat: lat ?? _lat,
        lon: lon ?? _lon,
      );
  num? get lat => _lat;
  num? get lon => _lon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lon'] = _lon;
    return map;
  }
}
