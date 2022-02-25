import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/views/edit_contact/edit_contact_view.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class AddNumberViewModel extends BaseViewModel {
  AddNumberViewModel(BuildContext context) {
    navigator = Navigator.of(context);
  }
  // Services
  late NavigatorState navigator;

  // Constants

  // Controllers
  final ScrollController scrollController = ScrollController();
  final textController = TextEditingController();

  // Variables
  List<Contact> sortedContacts = [];
  List<Contact> viewContacts = [];

  bool get validNumber => clearNumber.isNotEmpty;

  String get clearNumber => textController.text.replaceAll(RegExp(r'(?![\+\d]).'), '');

  // Logic

  Contact getContact(int index) {
    final Contact contact = viewContacts.elementAt(index);
    return contact;
  }

  Future onReady() async {
    setBusy(true);
    final contacts = await ContactsService.getContacts(withThumbnails: false);
    sortContacts(contacts.toList());
    if (sortedContacts != []) {
      viewContacts = sortedContacts;
    }
    setBusy(false);
  }

  void onChangedSearch(String text) {
    viewContacts = List.from(sortedContacts.where(
      (element) =>
          element.displayName!.toLowerCase().contains(text.toLowerCase()) ||
          element.phones!.any((element) =>
              element.value?.replaceAll(RegExp("( )+(-)+"), '').contains(text) ?? false),
    ));
    scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
    );
    notifyListeners();
  }

  void sortContacts(List<Contact> contacts) {
    sortedContacts = List.from(contacts.where((element) =>
        element.displayName != null && (element.phones?.isNotEmpty ?? false)));
  }

  Future<void> onContactTap(Contact contact) async {
    final tel =
        PhonebookPhone(phone: contact.phones!.first.value, name: contact.displayName);
    final ret = await navigator.push(EditContactViewRoute(tel));
    if (ret == null) return;
    navigator.pop(ret);
  }

  Future<void> onAddContactTap() async {
    final ret = await navigator
        .push(EditContactViewRoute(PhonebookPhone(phone: textController.text)));
    if (ret == null) return;
    navigator.pop(ret);
  }
}
