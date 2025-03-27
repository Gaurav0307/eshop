import 'dart:convert';

/// message : "User profile fetched!"
/// profile : {"_id":"67dd24f8edd91092e91a6cd6","fullname":"Anand Kumar","mobile":"+919876543211","image":"","chats":[{"_id":"67de71b8ee66c559110e61ac","name":"The Barber Shop","mobile":"+919876543210","image":"files\\business_image\\1742631352201-973442428-barber.jpeg"}],"createdAt":"2025-03-21T08:36:08.122Z","updatedAt":"2025-03-24T13:50:28.986Z","__v":16,"deviceId":"1234567890"}

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));
String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  UserProfileModel({
    String? message,
    Profile? profile,
  }) {
    _message = message;
    _profile = profile;
  }

  UserProfileModel.fromJson(dynamic json) {
    _message = json['message'];
    _profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }
  String? _message;
  Profile? _profile;
  UserProfileModel copyWith({
    String? message,
    Profile? profile,
  }) =>
      UserProfileModel(
        message: message ?? _message,
        profile: profile ?? _profile,
      );
  String? get message => _message;
  Profile? get profile => _profile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    if (_profile != null) {
      map['profile'] = _profile?.toJson();
    }
    return map;
  }
}

/// _id : "67dd24f8edd91092e91a6cd6"
/// fullname : "Anand Kumar"
/// mobile : "+919876543211"
/// image : ""
/// chats : [{"_id":"67de71b8ee66c559110e61ac","name":"The Barber Shop","mobile":"+919876543210","image":"files\\business_image\\1742631352201-973442428-barber.jpeg"}]
/// createdAt : "2025-03-21T08:36:08.122Z"
/// updatedAt : "2025-03-24T13:50:28.986Z"
/// __v : 16
/// deviceId : "1234567890"

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));
String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    String? id,
    String? fullname,
    String? mobile,
    String? image,
    List<Chats>? chats,
    String? createdAt,
    String? updatedAt,
    num? v,
    String? deviceId,
  }) {
    _id = id;
    _fullname = fullname;
    _mobile = mobile;
    _image = image;
    _chats = chats;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _deviceId = deviceId;
  }

  Profile.fromJson(dynamic json) {
    _id = json['_id'];
    _fullname = json['fullname'];
    _mobile = json['mobile'];
    _image = json['image'];
    if (json['chats'] != null) {
      _chats = [];
      json['chats'].forEach((v) {
        _chats?.add(Chats.fromJson(v));
      });
    }
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _deviceId = json['deviceId'];
  }
  String? _id;
  String? _fullname;
  String? _mobile;
  String? _image;
  List<Chats>? _chats;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  String? _deviceId;
  Profile copyWith({
    String? id,
    String? fullname,
    String? mobile,
    String? image,
    List<Chats>? chats,
    String? createdAt,
    String? updatedAt,
    num? v,
    String? deviceId,
  }) =>
      Profile(
        id: id ?? _id,
        fullname: fullname ?? _fullname,
        mobile: mobile ?? _mobile,
        image: image ?? _image,
        chats: chats ?? _chats,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
        deviceId: deviceId ?? _deviceId,
      );
  String? get id => _id;
  String? get fullname => _fullname;
  String? get mobile => _mobile;
  String? get image => _image;
  List<Chats>? get chats => _chats;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  String? get deviceId => _deviceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['fullname'] = _fullname;
    map['mobile'] = _mobile;
    map['image'] = _image;
    if (_chats != null) {
      map['chats'] = _chats?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['deviceId'] = _deviceId;
    return map;
  }
}

/// _id : "67de71b8ee66c559110e61ac"
/// name : "The Barber Shop"
/// mobile : "+919876543210"
/// image : "files\\business_image\\1742631352201-973442428-barber.jpeg"

Chats chatsFromJson(String str) => Chats.fromJson(json.decode(str));
String chatsToJson(Chats data) => json.encode(data.toJson());

class Chats {
  Chats({
    String? id,
    String? name,
    String? mobile,
    String? image,
  }) {
    _id = id;
    _name = name;
    _mobile = mobile;
    _image = image;
  }

  Chats.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _mobile = json['mobile'];
    _image = json['image'];
  }
  String? _id;
  String? _name;
  String? _mobile;
  String? _image;
  Chats copyWith({
    String? id,
    String? name,
    String? mobile,
    String? image,
  }) =>
      Chats(
        id: id ?? _id,
        name: name ?? _name,
        mobile: mobile ?? _mobile,
        image: image ?? _image,
      );
  String? get id => _id;
  String? get name => _name;
  String? get mobile => _mobile;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['mobile'] = _mobile;
    map['image'] = _image;
    return map;
  }
}
