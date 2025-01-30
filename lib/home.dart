import 'dart:developer';

import 'package:demo_project/ad_mob_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;
  int _rewardedAdScore = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createBannerAds();
    _createRewardedAds();
  }

  void _createRewardedAds() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => setState(() {
          _rewardedAd = ad; // ✅ Assign the loaded ad to `_rewardedAd`
        }),
        onAdFailedToLoad: (error) {
          log(error.toString());
        },
      ),
    );
  }

  void _showRewardedAds() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAds();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createRewardedAds();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          setState(() {
            _rewardedAdScore++;
          });
        },
      );
      _rewardedAd = null;
    }
  }

//
  void _createBannerAds() {
    try {
      _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId,
        listener: AdMobService.bannerAdListener,
        request: AdRequest(),
      )..load();
    } catch (e) {
      log(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ad mob"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            // _bannerAd == null
            //     ? Container()
            //     : Container(
            //         margin: EdgeInsets.only(bottom: 12),
            //         height: 52,
            //         child: AdWidget(ad: _bannerAd!),
            //       ),
            Text(
              "Rewarded Ad Score : ${_rewardedAdScore}",
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                _showRewardedAds();
              },
              child: Text(
                "On Pressed",
              ),
            ),
            Spacer(),
            SizedBox(
              height: 30,
            ),
            Spacer(),
          ],
        ),
      ),
      // bottomNavigationBar: _bannerAd == null
      //     ? Container()
      //     : Container(
      //         margin: EdgeInsets.only(bottom: 0),
      //         height: 52,
      //         child: AdWidget(ad: _bannerAd!),
      //       ),
    );
  }
}
