import 'package:ecommerce_flutter_admin/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class DasboardButtonWidget extends StatelessWidget {
  const DasboardButtonWidget({
    super.key,
    required this.text,
    required this.imagePath,
    required this.onPressed

  });

  final String text, imagePath;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: (){
        onPressed();
      },
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath,
                height: 50,
                width: 50,
              ),
              const SizedBox(
                height: 10,
              ),
              SubTitleTextWidget(label: text)

            ],


          ),
        ),
      ),
    );
  }
}
