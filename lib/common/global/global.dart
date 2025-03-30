import 'package:eshop/common/global/selected_location.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../controllers/auth_controller.dart';
import '../../controllers/business_service_controller.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/user_profile_controller.dart';
import '../services/location.dart';

SharedPreferences? sharedPreferences;
late IO.Socket socket;

late String token;
late String userId;
late String userMobile;

String deviceId = "";

// const String apiBaseUrl = "https://rest-apis-chat-app.onrender.com";
const String apiBaseUrl =
    "https://fe59-2401-4900-8836-78c9-1807-8bff-e61e-876e.ngrok-free.app";

/// One Signal
const String oneSignalAppId = "a1583783-9e3f-4045-9953-2cc1b9e1ee24";

var locationService = Get.put(LocationService());
var selectedLocation = Get.put(SelectedLocation());
var authController = Get.put(AuthController());
var userProfileController = Get.put(UserProfileController());
var categoryController = Get.put(CategoryController());
var businessServiceController = Get.put(BusinessServiceController());

final demoCategories = [
  {
    'category': 'Grocery',
    'imageUrl':
        'https://plus.unsplash.com/premium_photo-1661381007965-b21e0fb0681b?q=80&w=2071'
  },
  {
    'category': 'Electronics',
    'imageUrl':
        'https://images.unsplash.com/photo-1604335399105-a0c585fd81a1?q=80&w=2070'
  },
  {
    'category': 'Barber',
    'imageUrl':
        'https://images.unsplash.com/photo-1605497788044-5a32c7078486?q=80&w=1974'
  },
  {
    'category': 'Laundry',
    'imageUrl':
        'https://images.unsplash.com/photo-1567113463300-102a7eb3cb26?q=80&w=2070'
  },
  {
    'category': 'Beautician',
    'imageUrl':
        'https://plus.unsplash.com/premium_photo-1683121233219-a1192c107a9d?q=80&w=2070'
  },
  {
    'category': 'Doctor',
    'imageUrl':
        'https://plus.unsplash.com/premium_photo-1661580574627-9211124e5c3f?q=80&w=1974'
  },
  {
    'category': 'Hardware',
    'imageUrl':
        'https://plus.unsplash.com/premium_photo-1664301142625-e1742b2906e9?q=80&w=2070'
  },
  {
    'category': 'Bakery',
    'imageUrl':
        'https://images.unsplash.com/photo-1583338917451-face2751d8d5?q=80&w=1974'
  },
  {
    'category': 'Restaurant',
    'imageUrl':
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=2070'
  },
  {
    'category': 'Car Wash',
    'imageUrl':
        'https://images.unsplash.com/photo-1632685062337-095b722134ca?q=80&w=2070'
  },
];

final List<Map<String, dynamic>> demoServices = [
  {
    'imageUrl':
        "https://images.unsplash.com/photo-1605497788044-5a32c7078486?q=80&w=1974",
    'name': "The Barber Shop",
    'category': "Barber",
    'timing': "8:00 am - 9:00 pm",
    'servicesAndProducts':
        "Haircuts & Styling, Beard & Mustache Grooming, Shaving & Facial Treatments, Hair & Scalp Treatments, Coloring & Grooming",
    'address': "Zero Mile",
    'city': "Bhagalpur",
    'state': "Bihar",
    'location': {
      'lat': 25.253463,
      'lon': 87.021955,
    },
    'rating': 4.5,
    'peopleRated': 12345,
  },
  {
    'imageUrl':
        "https://images.unsplash.com/photo-1632685062337-095b722134ca?q=80&w=2070",
    'name': "The Car Wash",
    'category': "Car Wash",
    'timing': "9:00 am - 6:00 pm",
    'servicesAndProducts': "Car Wash, Bike Wash & Bus Wash",
    'address': "Sabour",
    'city': "Bhagalpur",
    'state': "Bihar",
    'location': {
      'lat': 25.243428,
      'lon': 87.047683,
    },
    'rating': 4.6,
    'peopleRated': 123456,
  }
];

final List<Map<String, dynamic>> demoBusinesses = [
  {
    'imageUrl':
        "https://images.unsplash.com/photo-1583338917451-face2751d8d5?q=80&w=1974",
    'name': "The Bakery Shop",
    'category': "Bakery",
    'timing': "10:00 am - 8:00 pm",
    'servicesAndProducts':
        "Cakes, Breads, Pastries, Cookies, Biscuits, Muffins & Doughnuts",
    'address': "Tilkamanjhi",
    'city': "Bhagalpur",
    'state': "Bihar",
    'location': {
      'lat': 25.253991,
      'lon': 87.000926,
    },
    'rating': 4.6,
    'peopleRated': 12345,
  },
  {
    'imageUrl':
        "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=2070",
    'name': "The Pop Restaurant",
    'category': "Restaurant",
    'timing': "11:00 am - 10:00 pm",
    'servicesAndProducts': "Indian, Chinese, Thai & Italian Dishes",
    'address': "Khalifagagh",
    'city': "Bhagalpur",
    'state': "Bihar",
    'location': {
      'lat': 25.246883,
      'lon': 86.976625,
    },
    'rating': 4.7,
    'peopleRated': 1234567,
  },
];
