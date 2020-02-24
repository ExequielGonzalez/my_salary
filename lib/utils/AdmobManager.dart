import 'package:admob_flutter/admob_flutter.dart';

class AdmobManager {
  //! Singleton
  static AdmobManager _instance;

  AdmobManager._() {
    _admobInterstitial = AdmobInterstitial(
        adUnitId: _isTest ? test_interstitial_id : interstitial_id,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.loaded) {
            _admobInterstitial.show();
          } else if (event == AdmobAdEvent.closed) {
            _admobInterstitial.dispose();
          }
        });
  }

  static AdmobManager get adManager =>
      _instance = _instance ?? AdmobManager._();

  //!Singleton

  static bool _isTest = true; //se debe poner a false para el release

  /** Test IDs **/
  static String test_app_id = "ca-app-pub-3940256099942544~3347511713";
  static String test_banner_id = "ca-app-pub-3940256099942544/6300978111";
  static String test_interstitial_id = 'ca-app-pub-3940256099942544/1033173712';

  /** You real IDs **/
  static String app_id = "ca-app-pub-3940256099942544~3347511713";
  static String banner_id = "ca-app-pub-3940256099942544/6300978111";
  static String interstitial_id = "ca-app-pub-3940256099942544/6300978111";

  AdmobInterstitial _admobInterstitial;

  static Admob initAdMob() {
    print("initAdMob");
    return Admob.initialize(_isTest ? test_app_id : app_id);
  }

  static AdmobBanner getBanner() {
    return AdmobBanner(
      adUnitId: _isTest ? test_banner_id : banner_id,
      adSize: AdmobBannerSize.BANNER,
    );
  }

  static AdmobBanner banner = AdmobBanner(
    adUnitId: _isTest ? test_banner_id : banner_id,
    adSize: AdmobBannerSize.BANNER,
  );

  loadAdvert() {
    _admobInterstitial.load();
  }

  createAdvert() {
    AdmobInterstitial(
        adUnitId: _isTest ? test_interstitial_id : interstitial_id,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.loaded) {
            _admobInterstitial.show();
          } else if (event == AdmobAdEvent.closed) {
            _admobInterstitial.dispose();
          }
        });
  }
}
