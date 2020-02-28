import 'package:admob_flutter/admob_flutter.dart';

class AdmobManager {
  //! Singleton
  static AdmobManager _instance;

  AdmobManager._() {
    _admobInterstitial = AdmobInterstitial(
        adUnitId: _isTest ? testInterstitialId : interstitialId,
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

  //! Test IDs
  static String testAppId = "ca-app-pub-3940256099942544~3347511713";
  static String testBannerId = "ca-app-pub-3940256099942544/6300978111";
  static String testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';

  //!You real IDs
  static String appId = "ca-app-pub-3940256099942544~3347511713";
  static String bannerId = "ca-app-pub-3940256099942544/6300978111";
  static String interstitialId = "ca-app-pub-3940256099942544/6300978111";

  AdmobInterstitial _admobInterstitial;

  static Admob initAdMob() {
    print("initAdMob");
    return Admob.initialize(_isTest ? testAppId : appId);
  }

  static AdmobBanner getBanner() {
    return AdmobBanner(
      adUnitId: _isTest ? testBannerId : bannerId,
      adSize: AdmobBannerSize.BANNER,
    );
  }

  static AdmobBanner banner = AdmobBanner(
    adUnitId: _isTest ? testBannerId : bannerId,
    adSize: AdmobBannerSize.BANNER,
  );

  loadAdvert() {
    _admobInterstitial.load();
  }

  createAdvert() {
    AdmobInterstitial(
        adUnitId: _isTest ? testInterstitialId : interstitialId,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.loaded) {
            _admobInterstitial.show();
          } else if (event == AdmobAdEvent.closed) {
            _admobInterstitial.dispose();
          }
        });
  }
}
