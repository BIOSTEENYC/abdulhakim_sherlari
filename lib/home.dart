import 'dart:convert';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon/Piktogramma.png"),
              fit: BoxFit.cover,
              colorFilter:
                  ColorFilter.mode(Colors.black45, BlendMode.multiply))),
      child: Column(
        children: [
          Expanded(
              child: Image.asset(
            "assets/icon/Piktogramma.png",
            fit: BoxFit.contain,
          )),
          SizedBox(
            height: 8,
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.yellow,
                  width: 2,
                ),
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [Colors.black, Colors.green, Colors.black],
                  tileMode: TileMode.decal,
                )),
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "Xayitboyev Abdulhakim\n2004 - yilda tug'ilgan. Flutter dasturchi va Havaskor shoir",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
                ),
                Expanded(flex: 2, child: SizedBox()),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Poems()));
                  },
                  child: Text(
                    "She'rlarni o'qish",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Expanded(child: SizedBox())
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class Poems extends StatefulWidget {
  const Poems({super.key});

  @override
  State<Poems> createState() => _PoemsState();
}

class _PoemsState extends State<Poems> {
  List data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    String dataJson =
        await DefaultAssetBundle.of(context).loadString("assets/data.json");
    setState(() {
      data = jsonDecode(dataJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/icon/Piktogramma.png"),
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black45, BlendMode.multiply)),
          ),
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 12,
                    borderRadius: BorderRadius.circular(20),
                    child: ListTile(
                      title: ListTile(
                        leading: CircleAvatar(
                          child: Text("${index + 1}"),
                        ),
                        title: Text(
                          data[index]["title"],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text("fff"),
                      ),
                      subtitle: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Material(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(data[index]["text"],style: Theme.of(context).textTheme.titleLarge,),
                                            ),
                                          ],
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Yopish",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Text(
                          "O'qish",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
