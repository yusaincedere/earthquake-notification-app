import 'package:flutter/material.dart';

import 'dataBaseHandler.dart';
import 'deprem.dart';
import 'main.dart';

final Color darkRed = Color.fromARGB(255, 255, 30, 0  );

class AramaEkrani extends StatefulWidget{
  AramaEkrani(): super();
  @override
  AramaEkraniState createState()  => AramaEkraniState();
}

class AramaEkraniState extends State<AramaEkrani>{
  late DatabaseHandler handler;
  String boyut = "1";
  List<Deprem> depremler = [];
  @override
  Widget build(BuildContext context) {
    late DatabaseHandler handler;
    return Scaffold(
      body: buildBody(),
      appBar: AppBar(
        backgroundColor: darkRed,
        title: Text("Depremler"),
        leading:
        IconButton(icon:Icon(Icons.arrow_back),
          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context){return HomePage();},),);},
        ),
        actions: [
          DropdownButton<String>(
            items: <String>['1', '2', '3', '4'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (String? deger){
              setState(() {
                this.boyut = deger!;
              });
            },
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
  }

  Widget buildBody() {
    return FutureBuilder(
        future: this.handler.depremAra(boyut),
        builder: (BuildContext context, AsyncSnapshot<List<Deprem>> snapshot){
          if (snapshot.hasData){
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index){
                Deprem deprem = snapshot.data![index];
                return Container(child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child:
                    Column(
                      children: [
                        bolge(deprem.bolge),
                      ],),

                    ),
                    Expanded(child:
                    Column(
                      children: [
                        bolge(deprem.buyukluk),
                      ],),

                    ),
                    Expanded(child:
                    Column(
                      children: [
                        bolge(deprem.tarih),
                      ],),
                    ),
                  ],
                ));
              },
            );
          }else{
            return Text(" ");
          }
        });
  }
  bolge(bolge){
    return Text(
      bolge,
      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
  buyukluk(buyukluk){
    return Text(
      buyukluk,
      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
  tarih(tarih){
    return Text(
      tarih,
      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}