import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
late String token;
late String userId;

final demoData = [
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
];

const String apiBaseUrl = "https://rest-apis-chat-app.onrender.com";
// const String apiBaseUrl =
//     "https://4351-2401-4900-8837-2bd3-2df5-57d8-4351-7750.ngrok-free.app";
