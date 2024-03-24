import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bts/components/custom_cached_network_image.dart';
import 'package:ecommerce_bts/models/user.dart';
import 'package:ecommerce_bts/ui/profils_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserListAdmin extends StatefulWidget {
  const UserListAdmin({super.key});

  @override
  State<UserListAdmin> createState() => _UserListAdminState();
}

class _UserListAdminState extends State<UserListAdmin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes utilisateurs"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading..');
          }
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return _buildUserListItem(doc);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: 3,
              );
            },
            // children: snapshot.data!.docs
            //     .map<Widget>((doc) => _buildUserListItem(doc))
            //     .toList(),
          );
        },
      ),
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // print(data);
    Users u = Users.fromMap(data);
    if (kDebugMode) {
      print(_auth.currentUser!);
    }
    //display all user except current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        trailing: Wrap(
          alignment: WrapAlignment.spaceAround,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            // if (data['status'] != true)
            //   ClipOval(
            //       child: Container(
            //           decoration:
            //               const BoxDecoration(color: Colors.greenAccent),
            //           child: IconButton(
            //             onPressed: () {
            //               // ChatService().updateStatutsUser(document.id);
            //             },
            //             icon: const Icon(
            //               Icons.check,
            //               size: 30,
            //               color: Colors.white,
            //             ),
            //           ))),
            if (data['status'] != true)
              const SizedBox(
                width: 10,
              ),
            ClipOval(
                child: Container(
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: IconButton(
                      onPressed: () {
                        // ChatService().deleteUser(document.id);
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        size: 25,
                        color: Colors.redAccent,
                      ),
                    ))),
          ],
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data['profilUrl']),
          child: ClipOval(
              child: CustomCachedNetworkImage(
            cover: BoxFit.cover,
            imageUrl: data['profilUrl'] != null
                ? data['profilUrl']
                : "https://api-private.atlassian.com/users/7831f16b18333c732e152c74f1863d18/avatar",
          )),
        ),
        title: Text(data['nom']),
        subtitle: Text(data['email']),
        onTap: () {
          // afficher l'uid de tous les utilisateurs cliques sur la page de discution

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                        users: u,
                        canUpdate: false,
                      )));
        },
      );
    } else {
      //return empty container
      return Container();
    }
  }
}
