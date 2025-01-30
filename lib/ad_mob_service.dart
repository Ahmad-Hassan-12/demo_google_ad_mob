import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String bannerAdUnitId = "ca-app-pub-3940256099942544/9214589741";

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => log("AD Loaded"),
    onAdFailedToLoad: (ad, error) {
      try {
        ad.dispose();
        log("Ad failed loaded");
        log(
          error.toString(),
        );
      } catch (e) {
        log(e.toString());
      }
    },
    onAdOpened: (ad) => log("Ad Opened"),
    onAdClosed: (ad) => log("Ad Closed"),
  );
  static String rewardedAdUnitId = "ca-app-pub-3940256099942544/5224354917";
  
}
