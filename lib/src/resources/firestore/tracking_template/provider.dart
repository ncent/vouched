import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/tracking.dart';
import 'package:vouched/src/models/tracking_template.dart';

class TrackingTemplateProvider {
  final CollectionReference tkTplCollection =
      Firestore.instance.collection('tracking_templates');

  Future<DocumentReference> create(TrackingTemplate tkTpl) async {
    return tkTplCollection.add(tkTpl.toJson());
  }

  Future<DocumentSnapshot> getByID(String id) {
    return tkTplCollection.document(id).get();
  }

  Future<QuerySnapshot> getByTxAction(TrackingAction tkAction) {
    return tkTplCollection
        .where('txAction', isEqualTo: tkAction.toString().split('.').last)
        .limit(1)
        .getDocuments();
  }
}
