import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_names/src/services/services.dart';
import 'package:band_names/src/models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Band> bands = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBand);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  void _handleActiveBand( dynamic data ) {
    bands = (data as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: true);

    return Scaffold(

      appBar: AppBar(
        elevation: 1,
        title: const Text( 'Band Names', style: TextStyle(color: Colors.black87) ),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only( right: 10 ),
            child:
              socketService.serverStatus == ServerStatus.online
              ? Icon( Icons.check_circle, color: Colors.blue[300] )
              : Icon( Icons.offline_bolt, color: Colors.red[300] )
          )
        ],
      ),

      body: Column(
        children: [
          if (bands.isNotEmpty) _showGraph(),

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) => _bandTile(bands[index])
            )
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon( Icons.add ),
      ),

    );
  }

  Widget _bandTile( Band band ) {
    // final socketService = Provider.of<SocketService>(context, listen: true);

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
          final socketService = Provider.of<SocketService>(context, listen: false);
          socketService.emit('remove-band', { 'id': band.id });
        }
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text( band.name.substring(0,2) )
        ),
        title: Text( band.name ),
        trailing: Text( '${band.votes}', style: const TextStyle( fontSize: 20 ) ),
        onTap: () {
          final socketService = Provider.of<SocketService>(context, listen: false);
          socketService.emit('vote-band', { 'id': band.id });
        },
      ),
    );
  }

  addNewBand() {

    final textEditingController = TextEditingController();

    if (kIsWeb) {
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
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', { 'name': name });
    }

    Navigator.pop(context);

  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};
    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }

    final List<Color> colorList = [
      Colors.blue,
      Colors.blueAccent,
      Colors.pink,
      Colors.pinkAccent,
      Colors.yellow,
      Colors.yellowAccent,
    ];

    return PieChart(
      dataMap: dataMap,
      // animationDuration: Duration(milliseconds: 800),
      // chartLegendSpacing: 32,
      // chartRadius: MediaQuery.of(context).size.width / 3.2,
      // colorList: colorList,
      // initialAngleInDegree: 0,
      // chartType: ChartType.ring,
      // ringStrokeWidth: 32,
      // centerText: "HYBRID",
      // legendOptions: const LegendOptions(
      //   showLegendsInRow: false,
      //   legendPosition: LegendPosition.right,
      //   showLegends: true,
      //   // legendShape: _BoxShape.circle,
      //   legendTextStyle: TextStyle(
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
      // chartValuesOptions: const ChartValuesOptions(
      //   showChartValueBackground: true,
      //   showChartValues: true,
      //   showChartValuesInPercentage: false,
      //   showChartValuesOutside: false,
      //   decimalPlaces: 1,
      // ),
      // gradientList: ---To add gradient colors---
      // emptyColorGradient: ---Empty Color gradient---
    );
  }

}
