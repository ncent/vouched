import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/tracking.dart';
import 'package:vouched/src/resources/firestore/tracking/provider.dart';

class TrackingRepository {
  final _tkProvider = TrackingProvider();

  Future<DocumentReference> create(Tracking tk) => _tkProvider.create(tk);
}
