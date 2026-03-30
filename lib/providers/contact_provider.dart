import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/contact.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> contacts = [];
  DBHelper db = DBHelper();

  Future<void> loadContacts() async {
    contacts = await db.getContacts();

    if (contacts.isEmpty) {
      await addDefaultContacts();
    }

    contacts = await db.getContacts();
    notifyListeners();
  }

  Future<void> addDefaultContacts() async {
    await db.insert(
      Contact(name: "Rahul", phone: "9876543210", email: "rahul@gmail.com"),
    );
    await db.insert(
      Contact(name: "Anjali", phone: "9123456780", email: "anjali@gmail.com"),
    );
    await db.insert(
      Contact(name: "Arjun", phone: "9988776655", email: "arjun@gmail.com"),
    );
    await db.insert(
      Contact(name: "Priya", phone: "9012345678", email: "priya@gmail.com"),
    );
    await db.insert(
      Contact(name: "Vikram", phone: "9090909090", email: "vikram@gmail.com"),
    );
  }

  Future<void> addContact(Contact contact) async {
    await db.insert(contact);
    loadContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await db.update(contact);
    loadContacts();
  }

  Future<void> deleteContact(int id) async {
    await db.delete(id);
    loadContacts();
  }
}
