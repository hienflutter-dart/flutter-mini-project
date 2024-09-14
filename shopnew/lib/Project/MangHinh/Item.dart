import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';


class Item extends StatelessWidget{
  var sp;
  Item( {super.key, required  this.sp});
  @override
  Widget build(BuildContext context){
    return ImageSlideshow(
      indicatorColor: Colors.redAccent,
      indicatorBackgroundColor: Colors.white38,
      height: 300,
      autoPlayInterval: 3000,
      indicatorRadius: 4,
      isLoop: true,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset("images/${sp[2]}.jpg"),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset("images/${sp[2]}.jpg"),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset("images/${sp[2]}.jpg"),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset("images/${sp[2]}.jpg"),
        ),
      ],
    );
  }
}