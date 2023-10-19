

import 'package:abdulhakim_sherlari/Sahifalar/Sahifalar.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Asosiy(title: "Abdulhakim She'rlari"),
    );
  }
}

class Asosiy extends StatefulWidget {
  const Asosiy({super.key, required this.title});
  final String title;
  @override
  State<Asosiy> createState() => _AsosiyState();
}
class _AsosiyState extends State<Asosiy> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              filterQuality: FilterQuality.low,
              fit: BoxFit.fill,
              image: AssetImage("assets/0.BannerFilter.png")
            )
          ),
          child: AspectRatio(
            aspectRatio: 9/16,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/0.Banner.png"))
              ),
              child: MaterialButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Mundarija()));
              })
            ),
          ),
        ),
      ),
    );
  }
}
