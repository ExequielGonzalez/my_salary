import 'package:admob_flutter/admob_flutter.dart';

class AdmobManager {
  static bool _isTest = true;

  /** Test IDs **/
  static String test_app_id = "ca-app-pub-3940256099942544~3347511713";
  static String test_banner_id = "ca-app-pub-3940256099942544/6300978111";

  /** You real IDs **/
  static String app_id = "ca-app-pub-3940256099942544~3347511713";
  static String banner_id = "ca-app-pub-3940256099942544/6300978111";

  static Admob initAdMob() {
    print("initAdMob");
    return Admob.initialize(_isTest ? test_app_id : app_id);
  }

  static AdmobBanner bottomBanner = AdmobBanner(
    adUnitId: _isTest ? test_banner_id : banner_id,
    adSize: AdmobBannerSize.BANNER,
  );

  static AdmobBanner finishBanner = AdmobBanner(
    adUnitId: _isTest ? test_banner_id : banner_id,
    adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
  );
}
