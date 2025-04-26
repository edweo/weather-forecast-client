import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          Text("Project Weather",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 15,),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.secondary,
              ),
              children: const [
                TextSpan(text: 'This is an application developed using '),
                TextSpan(text: 'Flutter ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'and the '),
                TextSpan(text: 'OpenWeatherMap API ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'for displaying weather information.'),
              ]
            )
          ),
          const SizedBox(height: 100,),
          const SizedBox(height: 5,),
          Text("App Version: 1.0.5",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary
            ),
          ),
          const SizedBox(height: 5,),
        ],
      )
    );
  }
}

