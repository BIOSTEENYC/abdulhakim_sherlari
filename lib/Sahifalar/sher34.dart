import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Sher34 extends StatelessWidget {
  Future<String> _matnFayldanOqish() async {
    String matn = await rootBundle.loadString('assets/34.txt');
    return matn;
  }
  const Sher34({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_circle_left_rounded,color: Colors.blue,))
        ],
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 9/16,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                     image: AssetImage('assets/34.png'))),
            child: Padding(
              padding: const EdgeInsets.only(top: 210,bottom: 50,left: 20,right: 20),
              child: ListView(
                children: [
                  FutureBuilder(
                      future: _matnFayldanOqish(),
                      builder:
                          (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Center(child: FittedBox(
                              fit: BoxFit.fill,
                              child: Text(snapshot.data.toString(),style: TextStyle(fontSize: 20),)));
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
