import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> contacts = [];
  DBHelper db = DBHelper();

  Future<void> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();

    bool isFirstLoad = prefs.getBool('isFirstLoad') ?? true;

    contacts = await db.getContacts();

    if (isFirstLoad && contacts.isEmpty) {
      await addDefaultContacts();
      contacts = await db.getContacts();

      await prefs.setBool('isFirstLoad', false);
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
