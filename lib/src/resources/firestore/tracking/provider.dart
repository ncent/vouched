import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/tracking.dart';

class TrackingProvider {
  final CollectionReference tkCollection =
      Firestore.instance.collection('tracking');

  Future<DocumentReference> create(Tracking tk) async {
    return tkCollection.add(tk.toJson());
  }
}
