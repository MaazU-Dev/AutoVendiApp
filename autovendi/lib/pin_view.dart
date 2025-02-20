import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'domain/model/model.dart';

class PinView extends StatefulWidget {
  const PinView({super.key});

  @override
  State<PinView> createState() => _PinViewState();
}

class _PinViewState extends State<PinView> {
  LocationAxis locationAxis = LocationAxis(x: 0, y: 0, z: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            'Pin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.grey,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: FirebaseDatabase.instance.ref("Pin/").onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Your Pin is: ',
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: snapshot.data!.snapshot.value.toString(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
