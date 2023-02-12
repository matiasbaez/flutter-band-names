import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/src/models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Linkin Park', votes: 5),
    Band(id: '3', name: 'Bon Jovi', votes: 5),
    Band(id: '4', name: 'The Beatles', votes: 5),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        elevation: 1,
        title: const Text( 'Band Names', style: TextStyle(color: Colors.black87) ),
        backgroundColor: Colors.white,
      ),

      body: ListView.builder(
        itemCount: bands.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => _bandTile(bands[index])
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon( Icons.add ),
      ),

    );
  }

  Widget _bandTile( Band band ) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only( left: 8.0 ),
        child: const  Align(
          alignment: Alignment.centerLeft,
          child: Text( 'Delete band', style: TextStyle( color: Colors.white ) )
        ),
      ),
      onDismissed: (direction) {
        if (direction.toString() == 'DismissDirection.startToEnd') {

        }
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text( band.name.substring(0,2) )
        ),
        title: Text( band.name ),
        trailing: Text( '${band.votes}', style: const TextStyle( fontSize: 20 ) ),
        onTap: () {},
      ),
    );
  }

  addNewBand() {

    final textEditingController = TextEditingController();

    if (Platform.isAndroid) {

      return showDialog(
        context: context,
        
        builder: (context) => AlertDialog(
          title: const Text('New band name'),
          content: TextField( controller: textEditingController ),
          actions: [
            MaterialButton(
              onPressed: () => addBandToList( textEditingController.text ),
              elevation: 5,
              textColor: Colors.blue,
              child: const Text('Add'),
            )
          ],
        ),
      );

    }

    if (Platform.isIOS) {

      return showCupertinoDialog(
        context: context,
        
        builder: (context) => CupertinoAlertDialog(
          title: const Text('New band name'),
          content: CupertinoTextField( controller: textEditingController ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => addBandToList( textEditingController.text ),
              child: const Text('Add'),
            ),

            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );

    }


  }

  void addBandToList( String name ) {

    if (name.length > 1) {
      bands.add( Band( id: DateTime.now().toString(), name: name, votes: 0 ) );
      setState(() {});
    }

    Navigator.pop(context);

  }

}
