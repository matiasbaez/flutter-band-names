import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/src/services/services.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context, listen: true);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server status: ${socketService.serverStatus}')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.message ),
        onPressed: () {
          print(socketService);
          socketService.emit('message', { 'name': 'Flutter ' });
        }
      ),
    );
  }
}