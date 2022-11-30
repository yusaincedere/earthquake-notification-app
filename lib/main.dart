import 'package:deprem/dataBaseHandler.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webfeed/webfeed.dart';
import 'aramaEkrani.dart';
import 'deprem.dart';


AtomFeed? feed;
final Color darkBlue = Color.fromARGB(255, 0, 138, 230);
final Color darkRed = Color.fromARGB(255, 255, 30, 0  );

void main() {
  runApp(MyApp());
}

class MyApp extends  StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>{
  // GOOGLE MAP
  static const baslangicPos = CameraPosition(target: LatLng(41.015137, 28.979530),zoom: 6.5);
  List<LatLng> locations = [];
  late DatabaseHandler handler;

  Widget map =  Container(
    height: 250.0,
    child: GoogleMap(
      myLocationButtonEnabled: false,
      initialCameraPosition: baslangicPos,
    ),
  );

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      appBar: AppBar(
        backgroundColor: darkRed,
        title: Text("Depremler"),
        actions: [
          IconButton(icon:Icon(Icons.search),
            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context){return AramaEkrani();},),);},
          )
        ],
      ),
    );
  }

 Widget buildBody(){

    return ListView(
      children: [ map,Depremler(),
      ],
    );
  }
}

