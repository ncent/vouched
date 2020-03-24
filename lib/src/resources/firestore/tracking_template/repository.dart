import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/tracking.dart';
import 'package:vouched/src/models/tracking_template.dart';
import 'package:vouched/src/resources/firestore/tracking_template/provider.dart';

class TrackingTemplateRepository {
  final _tkTplProvider = TrackingTemplateProvider();

  Future<DocumentReference> create(TrackingTemplate tkTpl) =>
      _tkTplProvider.create(tkTpl);

  Future<DocumentSnapshot> getByID(String id) => _tkTplProvider.getByID(id);

  Future<QuerySnapshot> getByTxAction(TrackingAction tkAction) =>
      _tkTplProvider.getByTxAction(tkAction);
}
