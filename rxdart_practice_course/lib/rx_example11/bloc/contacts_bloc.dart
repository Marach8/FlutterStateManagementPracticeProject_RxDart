import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_practice_course/rx_example11/extensions/extensions.dart';
import 'package:rxdart_practice_course/rx_example11/models/contact_models.dart';

typedef _Snapshots = QuerySnapshot<Map<String, dynamic>>;
typedef _Document = DocumentReference<Map<String, dynamic>>;

// //This extension will modify the original stream (beacuse of whereType) by filtering the non-null values
// extension RemoveNull<T> on Stream<T?>{
//   Stream<T> get removeNull => whereType<T>();
// }
//This extension will create a new stream entirely (because of switchMap) with non-null values
extension Unwrap<T> on Stream<T?>{
  Stream<T> unwrap() => switchMap((value) async* {
    if(value != null){yield value;}
  });
}



@immutable 
class ContactBloc{
  final Sink<String?> userId; final Sink<Contact> createContact;
  final Sink<Contact> deleteContact; final Stream<Iterable<Contact>> listOfContacts;
  final StreamSubscription<void> createContactSubscription;
  final StreamSubscription<void> deleteContactSubscription;

  const ContactBloc._({
    required this.userId, required this.createContact, 
    required this.deleteContact, required this.listOfContacts, 
    required this.createContactSubscription, required this.deleteContactSubscription
  });

  void dispose(){userId.close(); createContact.close(); deleteContact.close();}

  factory ContactBloc(){
    final backend = FirebaseFirestore.instance;
    final userId = BehaviorSubject<String?>();

    final Stream<Iterable<Contact>> contacts = userId.switchMap((userId) {
      if(userId == null){return const Stream<_Snapshots>.empty();}
      else{return backend.collection(userId).snapshots();}
    }).map<Iterable<Contact>>((snapshot) sync*{
      for (final doc in snapshot.docs){yield Contact.fromFirebase(doc.data(), id: doc.id);}
    });

    final createContact = BehaviorSubject<Contact>();
    final createContactSubscription = createContact.switchMap((contactToCreate){
      return userId.take(1).unwrap().asyncMap((userId) 
        => backend.collection(userId).add(contactToCreate.toJson));
    }).listen((_){});

    final deleteContact = BehaviorSubject<Contact>();
    final deleteContactSubscription = deleteContact.switchMap((contactToDelete){
      return userId.take(1).unwrap().asyncMap((userId) 
        => backend.collection(userId).doc(contactToDelete.id).delete());
    }).listen((_){});

    return ContactBloc._(
      createContact: createContact,
      createContactSubscription: createContactSubscription,
      deleteContact: deleteContact,
      deleteContactSubscription: deleteContactSubscription,
      listOfContacts: contacts, userId: userId
    );
  }
}