import 'package:url_launcher/url_launcher.dart';
import 'package:zefyr/zefyr.dart';

class CustomAttrDelegate implements ZefyrAttrDelegate {
  CustomAttrDelegate();

  @override
  void onLinkTap(String value) async {
    if (await canLaunch(value)) {
      await launch(value);
    } else {
      throw 'Could not launch $value';
    }
  }
}
