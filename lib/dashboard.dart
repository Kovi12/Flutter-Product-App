import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_proj/product.dart';
import 'package:main_proj/product_repo.dart';

import 'login.dart';

class UserDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
      ),
      body: FutureBuilder<User>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                ListTile(
                  title: Text('Email'),
                  subtitle: Text(snapshot.data!.email),
                ),
                ListTile(
                  title: Text('UID'),
                  subtitle: Text(snapshot.data!.uid),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductsPage()),
                    );
                  },
                  child: Text('Go to Products Page'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Sign Out'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ProductRepoPage()),
                    );
                  },
                  child: Text('Product Repsotiory'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<User> getUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    return User(
      uid: user.uid,
      email: user.email!
    );
  }
}

class User {
  final String uid;
  final String email;

  User({
    required this.uid,
    required this.email
  });
}
