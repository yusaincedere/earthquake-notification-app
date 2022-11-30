import 'dart:async';
import 'dart:developer';
import "package:flutter/material.dart";
import 'package:webfeed/domain/rss_feed.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

import 'dataBaseHandler.dart';
class Depremler extends StatefulWidget{
  Depremler(): super();
  @override
  DepremlerState createState()  => DepremlerState();
}

class DepremlerState extends State<Depremler> {
  late DatabaseHandler handler;
  List<Deprem> depremler = [];
  String url = 'http://koeri.boun.edu.tr/rss/';
  Uri? FEED_URL;

  RssFeed? _feed;
  updateFeed(feed){
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      await this.addDepremler(feed);
    });
    setState(() {
      _feed = feed;
    });
  }

  load () async{
    loadFeed().then((result){
      if(null==result||result.toString().isEmpty){
        return null;
      }
      updateFeed(result);
    });
  }
  
  Future<RssFeed?> loadFeed() async{
    try{
      final client = http.Client();
      final response = await client.get(FEED_URL!);
      final utf16Body = utf8.decode(response.bodyBytes);
      return   RssFeed.parse(utf16Body);
    }catch(e){
      log(e.toString());
    }
    return null;
  }
  @override
  void initState() {
      super.initState();
      FEED_URL=Uri.parse(url);
      load();
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


  @override
  Widget build(BuildContext context) {
    return body();
  }
  isFeedEmpty(){
    return null == _feed || null ==_feed!.items;
  }
  list(){
    return FutureBuilder(
        future: this.handler.retrieveDeprem(),
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
  body(){
    return isFeedEmpty() ? Center(child: CircularProgressIndicator(),):list();
  }

 Future<int> addDepremler(RssFeed feed) async {
    for  (int i = 0;i< feed.items!.length;i++){
     String bolge = feed.items![i].title!.split(" ")[2];
     String buyukluk = feed.items![i].title!.split(" ")[0];
     String tarih = feed.items![i].description!.split(" ")[0];
     Deprem deprem = Deprem(bolge: bolge, buyukluk: buyukluk, tarih: tarih);
     depremler.add(deprem);
    }
    return await this.handler.insertDeprem(depremler);
 }
}
class Deprem{

  String? bolge;
  String? buyukluk;
  String? tarih;
  Deprem({
    required this.bolge,
    required this.buyukluk,
    required this.tarih,
});

  Deprem.fromMap(Map<String,dynamic> res)
  : bolge = res["bolge"],
    buyukluk = res["buyukluk"],
    tarih = res["tarih"];

  Map<String,Object?> toMap(){
    return {'bolge':bolge,'buyukluk':buyukluk,'tarih':tarih};
  }
}