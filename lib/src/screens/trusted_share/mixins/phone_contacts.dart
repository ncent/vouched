import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class PhoneContacts {
  bool isContactAccessGranted = false;
  bool isPermissionDenied = false;

  Future<Iterable<Contact>> getContactsAsStream() {
    return ContactsService.getContacts();
  }

  checkContactsPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission == PermissionStatus.granted) {
      isContactAccessGranted = true;
    } else {
      final result = await PermissionHandler()
          .requestPermissions([PermissionGroup.contacts]);

      if (result[PermissionGroup.contacts] == PermissionStatus.denied) {
        isPermissionDenied = true;
      }
    }
  }

  requestPermissionOnSettings() {
    PermissionHandler().openAppSettings();
  }
}
