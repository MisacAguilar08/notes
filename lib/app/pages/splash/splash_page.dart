import 'package:flutter/material.dart';
import 'package:notes/app/pages/task_list/task_list_page.dart';
import 'package:notes/app/utils/app_images.dart';


import '../../utils/app_texts.dart';
import '../../widgtes/images_task_list.dart';
import '../../widgtes/title_task_list.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Header(),
          SizedBox(height: sizeH * .05),
          ImagesTask(),
          SizedBox(height: sizeH * .075),
          TitleTask(),
          SizedBox(height: sizeH * .018),
          DescriptionTask(),
          Expanded(child: Container()),
          ButtonTask(context),
        ],
      ),
    );
  }

  Padding ButtonTask(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TaskList();
            }));
          },
          child: Text(AppTexts.titleButton)),
    );
  }

  Widget DescriptionTask() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Text(textAlign: TextAlign.center, AppTexts.splashDescription),
    );
  }

  Widget TitleTask() {
    return TitleTaskList(
      text: AppTexts.splashTitle,
    );
  }

  Widget ImagesTask() {
    return ImagesTaskList(
      nameImages: AppImages.onboarding,
      imageWidth: 180,
      imageHeight: 168,
    );
  }

  Widget Header() {
    return Row(
      children: [
        ImagesTaskList(
          nameImages: AppImages.shape,
          imageWidth: 141,
          imageHeight: 129,
        ),
      ],
    );
  }
}
