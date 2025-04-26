import 'package:flutter/material.dart';

class BoxButton extends StatelessWidget {
  Function? btnOnPress;
  String? errorMsg;
  String buttonText;
  BoxButton({super.key, required this.btnOnPress, required this.buttonText ,this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width*0.6,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Image.asset('assets/icons/weather_icon.png'),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              btnOnPress!();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onSurface),
            child: Text(
              buttonText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          if (errorMsg != null) const SizedBox(height: 5,),
          if (errorMsg != null) Text(errorMsg!, style: TextStyle(color: Theme.of(context).colorScheme.onError), textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}