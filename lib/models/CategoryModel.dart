import 'dart:convert';

/// message : "Categories fetched!"
/// categories : [{"_id":"67d927e6e91c4a33bcdfef39","title":"Grocery","image":"files\\category_image\\1742284774898-487016564-grocery.jpeg","createdAt":"2025-03-18T07:59:34.959Z","updatedAt":"2025-03-18T07:59:34.959Z","__v":0},{"_id":"67d934c5ee9abad8fda646ce","title":"Laundry","image":"files\\category_image\\1742379360785-199025110-laundry.jpeg","createdAt":"2025-03-18T08:54:29.736Z","updatedAt":"2025-03-19T10:16:00.879Z","__v":0},{"_id":"67dbdc98eae145963dc664e8","title":"Barber","image":"files\\category_image\\1742462104804-239355554-barber.jpeg","createdAt":"2025-03-20T09:15:04.872Z","updatedAt":"2025-03-20T09:15:04.872Z","__v":0},{"_id":"67e659689ad9d821b9319679","title":"Hardware","image":"files\\category_image\\1743149416738-55949909-hardware.jpeg","createdAt":"2025-03-28T08:10:16.822Z","updatedAt":"2025-03-28T08:10:16.822Z","__v":0},{"_id":"67e6598d9ad9d821b931967c","title":"Beautician","image":"files\\category_image\\1743149453282-71392081-beautician.jpeg","createdAt":"2025-03-28T08:10:53.333Z","updatedAt":"2025-03-28T08:10:53.333Z","__v":0},{"_id":"67e65a239ad9d821b931967f","title":"Electricals","image":"files\\category_image\\1743149603742-280499688-electrical.jpg","createdAt":"2025-03-28T08:13:23.788Z","updatedAt":"2025-03-28T08:13:23.788Z","__v":0},{"_id":"67e65a439ad9d821b9319682","title":"Stationary","image":"files\\category_image\\1743149635098-578509619-stationary.jpg","createdAt":"2025-03-28T08:13:55.152Z","updatedAt":"2025-03-28T08:13:55.152Z","__v":0},{"_id":"67e65ab89ad9d821b9319687","title":"Car & Bike Wash","image":"files\\category_image\\1743149751947-194357760-car_wash.jpeg","createdAt":"2025-03-28T08:15:52.002Z","updatedAt":"2025-03-28T08:15:52.002Z","__v":0},{"_id":"67e65ad79ad9d821b931968a","title":"Restaurant","image":"files\\category_image\\1743149783284-279435964-restaurant.jpeg","createdAt":"2025-03-28T08:16:23.338Z","updatedAt":"2025-03-28T08:16:23.338Z","__v":0},{"_id":"67e65af69ad9d821b931968d","title":"Bakery","image":"files\\category_image\\1743149814120-344566724-bakery.jpeg","createdAt":"2025-03-28T08:16:54.178Z","updatedAt":"2025-03-28T08:16:54.178Z","__v":0},{"_id":"67e65d439ad9d821b9319692","title":"Medical Store","image":"files\\category_image\\1743150403864-240915816-medical-store.jpg","createdAt":"2025-03-28T08:26:43.916Z","updatedAt":"2025-03-28T08:26:43.916Z","__v":0},{"_id":"67e65d6a9ad9d821b9319696","title":"Electronics","image":"files\\category_image\\1743150442844-255504462-electronics.jpeg","createdAt":"2025-03-28T08:27:22.896Z","updatedAt":"2025-03-28T08:27:22.896Z","__v":0},{"_id":"67e65da69ad9d821b931969a","title":"Electrician","image":"files\\category_image\\1743150502293-863369129-electrician.jpg","createdAt":"2025-03-28T08:28:22.345Z","updatedAt":"2025-03-28T08:28:22.345Z","__v":0},{"_id":"67e65df39ad9d821b931969d","title":"Plumber","image":"files\\category_image\\1743150579243-177179244-plumber.jpg","createdAt":"2025-03-28T08:29:39.290Z","updatedAt":"2025-03-28T08:29:39.290Z","__v":0},{"_id":"67e65e2c9ad9d821b93196a0","title":"Construction Worker","image":"files\\category_image\\1743150636614-627205876-construction-worker.jpg","createdAt":"2025-03-28T08:30:36.670Z","updatedAt":"2025-03-28T08:30:36.670Z","__v":0},{"_id":"67e65e509ad9d821b93196a3","title":"Painter","image":"files\\category_image\\1743150672813-744998296-painter.jpg","createdAt":"2025-03-28T08:31:12.866Z","updatedAt":"2025-03-28T08:31:12.866Z","__v":0},{"_id":"67e65e849ad9d821b93196a7","title":"Carpainter","image":"files\\category_image\\1743150724927-495991099-carpainter.jpg","createdAt":"2025-03-28T08:32:04.982Z","updatedAt":"2025-03-28T08:32:04.982Z","__v":0},{"_id":"67e65ead9ad9d821b93196aa","title":"Doctor","image":"files\\category_image\\1743150765685-869116318-doctor.jpeg","createdAt":"2025-03-28T08:32:45.738Z","updatedAt":"2025-03-28T08:32:45.738Z","__v":0}]

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));
String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    String? message,
    List<Categories>? categories,
  }) {
    _message = message;
    _categories = categories;
  }

  CategoryModel.fromJson(dynamic json) {
    _message = json['message'];
    if (json['categories'] != null) {
      _categories = [];
      json['categories'].forEach((v) {
        _categories?.add(Categories.fromJson(v));
      });
    }
  }
  String? _message;
  List<Categories>? _categories;
  CategoryModel copyWith({
    String? message,
    List<Categories>? categories,
  }) =>
      CategoryModel(
        message: message ?? _message,
        categories: categories ?? _categories,
      );
  String? get message => _message;
  List<Categories>? get categories => _categories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    if (_categories != null) {
      map['categories'] = _categories?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// _id : "67d927e6e91c4a33bcdfef39"
/// title : "Grocery"
/// image : "files\\category_image\\1742284774898-487016564-grocery.jpeg"
/// createdAt : "2025-03-18T07:59:34.959Z"
/// updatedAt : "2025-03-18T07:59:34.959Z"
/// __v : 0

Categories categoriesFromJson(String str) =>
    Categories.fromJson(json.decode(str));
String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
  Categories({
    String? id,
    String? title,
    String? image,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    _id = id;
    _title = title;
    _image = image;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  Categories.fromJson(dynamic json) {
    _id = json['_id'];
    _title = json['title'];
    _image = json['image'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _title;
  String? _image;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  Categories copyWith({
    String? id,
    String? title,
    String? image,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) =>
      Categories(
        id: id ?? _id,
        title: title ?? _title,
        image: image ?? _image,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        v: v ?? _v,
      );
  String? get id => _id;
  String? get title => _title;
  String? get image => _image;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['title'] = _title;
    map['image'] = _image;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }
}
