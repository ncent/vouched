import 'package:vouched/src/models/tracking.dart';

class TrackingTemplate {
  final TrackingAction txAction;
  final int points;
  final int version;
  final int maxNumTimes;

  TrackingTemplate({
    this.txAction,
    this.points,
    this.version,
    this.maxNumTimes,
  });

  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json['txAction'] = txAction.toString().split('.').last;
    json['points'] = points;
    json['version'] = version;
    json['maxNumTimes'] = maxNumTimes;
    return json;
  }
}
