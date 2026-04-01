import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/contact.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> contacts = [];
  DBHelper db = DBHelper();

  bool _isFirstLoad = true;

  Future<void> loadContacts() async {
    contacts = await db.getContacts();

    if (_isFirstLoad && contacts.isEmpty) {
      await addDefaultContacts();
      contacts = await db.getContacts();
      _isFirstLoad = false; 
    }

    notifyListeners();
  }

  Future<void> addDefaultContacts() async {
    await db.insert(
      Contact(
        name: "Rahul",
        phone: "9876543210",
        email: "rahul@gmail.com",
        nick: 'rah',
      ),
    );

    await db.insert(
      Contact(
        name: "Anjali",
        phone: "9123456780",
        email: "anjali@gmail.com",
        nick: 'anju',
      ),
    );

    await db.insert(
      Contact(
        name: "Arjun",
        phone: "9988776655",
        email: "arjun@gmail.com",
        nick: 'arju',
      ),
    );
  }

  Future<void> addContact(Contact contact) async {
    await db.insert(contact);
    await loadContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await db.update(contact);
    await loadContacts();
  }

  Future<void> deleteContact(int id) async {
    await db.delete(id);
    await loadContacts();
  }
}
