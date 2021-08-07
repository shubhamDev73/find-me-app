import 'package:findme/assets.dart';

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel({required this.imageAssetPath, required this.title, required this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  return List.of({
    new SliderModel(imageAssetPath: Assets.onBoardingOne, title: "find", desc: "discover people"),
    new SliderModel(imageAssetPath: Assets.onBoardingTwo, title: "me", desc: "discover thyself"),
    new SliderModel(imageAssetPath: Assets.onBoardingThree, title: "find.me", desc: "discover so much"),
  });
}
