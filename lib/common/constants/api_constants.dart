import '../global/global.dart';

class ApiConstants {
  static const String baseUrl = apiBaseUrl;

  /// Auth
  static const String register = "/auth/register"; // POST
  static const String login = "/auth/login"; // POST
  static const String sendRegisterOTP = "/auth/register/send-otp"; // POST
  static const String sendLoginOTP = "/auth/login/send-otp"; // POST
  static const String verifyOTP = "/auth/verify-otp"; // POST

  /// All Business/Services
  static const String allBusinessServices = "/business/getAll"; // GET
  static const String nearByBusinessService = "/business/getAllNearBy"; // POST

  /// Category
  static const String allCategories = "/category/getAll"; // GET

  /// Business/Services Rating
  static const String rateBusinessService = "/rating/rate"; // POST
  static const String businessServiceRating =
      "/rating/getRatings?businessServiceId="; // GET
  static const String deleteBusinessServiceRating =
      "/rating/deleteBusinessServiceRating?businessServiceId="; // DELETE

  /// Profile
  static const String userProfile = "/profile/getProfile"; // GET
  static const String updateUserProfile = "/profile/update"; // PUT
  static const String deleteUserProfile = "/profile/delete"; // DELETE

  /// User Business/Services
  static const String userBusinessService =
      "/business/getUserBusinesses"; // POST
  static const String createBusinessService = "/business/create"; // POST
  static const String updateBusinessService = "/business/update"; // PUT
  static const String deleteBusinessService =
      "/business/delete?businessServiceId="; // DELETE
  static const String sendOTP = "/business/send-otp"; // POST
  static const String verifyTheOTP = "/business/verify-otp"; // POST
  static const String userRegister = "/business/user-register"; // POST

  /// Chat
  static const String chats = "/chat/getMessages"; // POST
  static const String sendMessage = "/chat/send-message"; // POST
  static const String deleteMessage = "/chat/deleteMessage?chatId="; // DELETE
  static const String markMessageAsRead =
      "/chat/markMessageAsRead?chatId="; // PUT
}
