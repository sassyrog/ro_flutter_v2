import 'package:flutter/material.dart';
import 'package:pegaplay/data/constants.dart';
import 'package:pegaplay/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          KConstants.appName,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 40,
            children: [
              Card(
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Text("Hello World"),
                  ),
                ),
              ),
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 20,
                children: [
                  SizedBox(
                    width: 300,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Container(color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Container(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 20,
                children: [
                  SizedBox(
                    width: 300,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Container(color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Container(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 20,
                children: [
                  SizedBox(
                    width: 300,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Container(color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Container(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
