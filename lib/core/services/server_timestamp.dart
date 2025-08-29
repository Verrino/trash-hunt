import 'package:cloud_firestore/cloud_firestore.dart';

class ServerTimestamp {
  static Future<DateTime> get now async {
    final ref = FirebaseFirestore.instance.collection('meta').doc('_now');
    await ref.set({'now': FieldValue.serverTimestamp()});
    final snap = await ref.get();
    final serverNow = (snap['now'] as Timestamp).toDate();

    return serverNow;
  }
}