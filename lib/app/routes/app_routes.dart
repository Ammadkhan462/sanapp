part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const SPLASH = _Paths.SPLASH;
  static const SIGNUP = _Paths.SIGNUP;
  static const SIGNUP_DETAILS = _Paths.SIGNUP_DETAILS;
  static const VarificationView = _Paths.VarificationView;
  static const CROP = _Paths.CROP;
  static const CLIPEDITING = _Paths.CLIPEDITING;
}

abstract class _Paths {
  _Paths._();
  static const VarificationView = '/varification';
  static const SIGNUP_DETAILS =
      '/signupdetails'; // Define the path for signup details

  static const HOME = '/home';
  static const ONBOARDING = '/onboarding';
  static const SPLASH = '/splash';
  static const SIGNUP = '/signup';
  static const CROP = '/crop';
  static const CLIPEDITING = '/clipediting';
}
