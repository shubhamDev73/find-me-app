import 'package:findme/assets.dart';

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

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
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc("discover people");
  sliderModel.setTitle("find");
  sliderModel.setImageAssetPath(Assets.onBoardingOne);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc("discover thyself");
  sliderModel.setTitle("me");
  sliderModel.setImageAssetPath(Assets.onBoardingTwo);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc("discover so much");
  sliderModel.setTitle("find.me");
  sliderModel.setImageAssetPath(Assets.onBoardingThree);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
