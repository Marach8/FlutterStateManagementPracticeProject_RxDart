import 'package:flutter/material.dart';
import 'package:rxdart_practice_course/rx_example11/dialogs/error_dialogs.dart';
import 'package:rxdart_practice_course/rx_example11/extensions/typedefs.dart';
import 'package:rxdart_practice_course/rx_example11/models/contact_models.dart';
import 'package:rxdart_practice_course/rx_example11/views/popupview.dart';

class ContactListView extends StatelessWidget {
  final Contact contact; final DeleteContactCallback deleteContact;
  final LogoutCallback logout; final DeleteAccountCallback deleteAccount;
  final CreateContactCallback createContact;
  final Stream<Iterable<Contact>> contacts;

  const ContactListView({
    required this.contact, required this.deleteContact, required this.logout, 
    required this.deleteAccount, required this.createContact, super.key, 
    required this.contacts
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts View'), centerTitle: true,
        actions: [PopUpMenuView(logout: logout, deleteAccount: deleteAccount)]
      ),body: StreamBuilder<Iterable<Contact>>(
        stream: contacts,
        builder: (_, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting: 
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
            case ConnectionState.active: 
              if(snapshot.data == null){
                return const SizedBox.shrink();
              } else{
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, listIndex){
                    final contact = snapshot.data!.elementAt(listIndex);
                    return ContactListTile(contact: contact, deleteContact: deleteContact);
                  }
                );
              }            
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){createContact;}, child: const Icon(Icons.add)
      )
    );
  }
}





class ContactListTile extends StatelessWidget {
  final Contact contact; final DeleteContactCallback deleteContact;
  const ContactListTile({required this.contact, required this.deleteContact, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.fullName),
      trailing: IconButton(
        onPressed: () async{
          final shouldDeleteContact = await showDeleteContactDialog(context);
          if(shouldDeleteContact){deleteContact(contact);}
        }, 
        icon: const Icon(Icons.delete_rounded)
      )
    );
  }
}