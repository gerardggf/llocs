import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, this.uploadTask});

  final UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final datos = snapshot.data!;
          double progreso = datos.bytesTransferred / datos.totalBytes;

          return SizedBox(
              height: 50,
              child: Stack(fit: StackFit.expand, children: [
                LinearProgressIndicator(
                    value: progreso,
                    backgroundColor: Colors.grey,
                    color: Colors.green),
                Center(
                  child: Text(
                    "${(100 * progreso).roundToDouble()}%",
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ]));
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      },
    );
  }
}
