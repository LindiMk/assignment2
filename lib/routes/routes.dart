import 'package:assignment2/pages/adminPanel.dart';
import 'package:assignment2/pages/adminRegistration.dart';
import 'package:assignment2/pages/admin_reviews.dart';
import 'package:assignment2/pages/appointment.dart';
import 'package:assignment2/pages/homePage.dart';
import 'package:assignment2/pages/profile.dart';
import 'package:assignment2/pages/review.dart';
import 'package:assignment2/service/auth_page.dart';
import 'package:assignment2/service/login_or_register.dart';
import 'package:flutter/material.dart';

class RouteManager {
  //Define route names
  static const String authPage = '/';
  static const String login = '/login';
  static const String homePage = '/homePage';
  static const String appointment = '/appointment';
  static const String profile = '/profile';
  static const String review = '/review';
  static const String admin = '/adminRegistration'; 
  static const String adminReview = '/adminReview';
  static const String adminPanel = '/adminPanel';

  //Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //Switch statement to determine which route to generate
    switch (settings.name) {

      case authPage:
        return MaterialPageRoute(
          builder: (context) => const AuthPage()
        );

      case login:
        return MaterialPageRoute(
          builder: (context) => const LoginOrRegister()
        );

      case homePage:
        // Return MaterialPageRoute for Main page
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );

      case appointment:
        // Return MaterialPageRoute for Appointment page
        return MaterialPageRoute(
          builder: (context) => const Appointment(),
        );

      case profile:
        // Return MaterialPageRoute for Profile  page
        return MaterialPageRoute(
          builder: (context) => const Profile(),
        );

      case review:
        // Return MaterialPageRoute for Review  page
        return MaterialPageRoute(
          builder: (context) => const Review(),
        );

      case adminReview:
        return MaterialPageRoute(
          builder: (context) => const ReviewsManagementPage()
        );

      case admin:
        // Return MaterialPageRoute for Admin Registration  page
        return MaterialPageRoute(
          builder: (context) => const AdminRegistration(),
        );

      case adminPanel:
        return MaterialPageRoute(
          builder: (context) => const AdminPanel()
        );

      default:
        // Throw a FormatException if the route does not exist
        throw const FormatException("none of the pages exist");
    }
  }
}
