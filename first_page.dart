import 'package:flutter/material.dart';
import 'package:my_tutor_mob_app/pages/first_page_sub_pages/sub_page1.dart';
import 'package:my_tutor_mob_app/pages/first_page_sub_pages/sub_page2.dart';
import 'package:my_tutor_mob_app/pages/first_page_sub_pages/sub_page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FirstPage extends StatelessWidget {
 
  final _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 500,
            child: PageView(
              controller: _controller,
              children: const [
                SubPage3(),
                SubPage1(),
                SubPage2(),
                SubPage3()
              ]
            ),
          ),
          SmoothPageIndicator(controller: _controller, count: 3)
        ],
      )

    );
  }
}