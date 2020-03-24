import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/tracking.dart';
import 'package:vouched/src/resources/firestore/tracking/repository.dart';
import 'package:vouched/src/resources/firestore/tracking_template/repository.dart';

class TrackingBloc implements Bloc {
  final _trackingRepository = TrackingRepository();

  final _trackingTplRepository = TrackingTemplateRepository();

  Future<DocumentReference> track(Tracking tk) =>
      _trackingRepository.create(tk);

  Future<QuerySnapshot> getByTxAction(TrackingAction tkAction) =>
      _trackingTplRepository.getByTxAction(tkAction);

  @override
  void dispose() {}
}
