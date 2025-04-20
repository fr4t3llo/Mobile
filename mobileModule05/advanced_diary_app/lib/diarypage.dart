// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:diary_app/newdiary.dart';
import 'package:diary_app/details.dart';

class Diarypage extends StatefulWidget {
  const Diarypage({super.key});

  @override
  State<Diarypage> createState() => _DiarypageState();
}

class _DiarypageState extends State<Diarypage> {
  User? _currentUser;
  bool _isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    setState(() {
      _currentUser = _auth.currentUser;
      _isLoading = false;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    final navigatorContext = context;

    try {
      await _auth.signOut();
      await _googleSignIn.signOut();

      if (navigatorContext.mounted) {
        Navigator.of(navigatorContext).pushReplacementNamed('/');
      }
    } catch (e) {
      if (navigatorContext.mounted) {
        ScaffoldMessenger.of(
          navigatorContext,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
      }
    }
  }

  Future<void> _deleteEntry(String documentId) async {
    try {
      await _firestore.collection('diary_entries').doc(documentId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entry deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting entry: $e')));
      }
    }
  }

  Future<void> _addNewEntry(BuildContext context) async {
    if (_currentUser == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewEntryPage(userId: _currentUser!.uid),
      ),
    );

    // Refresh the diary list if a new entry was added
    if (result == true) {
      setState(() {});
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            title: const Text('Delete Entry'),
            content: const Text(
              'Are you sure you want to delete this diary entry?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'DELETE',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.indigo.shade100,
            backgroundImage:
                _currentUser?.photoURL != null
                    ? NetworkImage(_currentUser!.photoURL!)
                    : null,
            child:
                _currentUser?.photoURL == null
                    ? const Icon(Icons.person, size: 40, color: Colors.indigo)
                    : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentUser?.displayName ?? 'User',
                  style: TextStyle(
                    color: Colors.indigo.shade800,
                    fontFamily: 'my_2',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                FutureBuilder<QuerySnapshot>(
                  future:
                      _firestore
                          .collection('diary_entries')
                          .where('userId', isEqualTo: _currentUser?.uid)
                          .get(),
                  builder: (context, snapshot) {
                    int entryCount =
                        snapshot.hasData ? snapshot.data!.docs.length : 0;
                    return Text(
                      '$entryCount diary entries',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore
              .collection('diary_entries')
              .where('userId', isEqualTo: _currentUser?.uid)
              .orderBy('date', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          debugPrint("${snapshot.error}");
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No diary entries yet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.amber),
                  label: const Text('Create First Entry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () => _addNewEntry(context),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final date = (data['date'] as Timestamp).toDate();

            return _buildEntryCard(doc.id, data, date);
          },
        );
      },
    );
  }

  Widget _buildEntryCard(
    String docId,
    Map<String, dynamic> data,
    DateTime date,
  ) {
    return Dismissible(
      key: Key(docId),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => _deleteEntry(docId),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                data['emoji'] ?? '📝',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          title: Text(
            data['title'] ?? 'No Title',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              DateFormat('MMM dd, yyyy').format(date),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: () async {
                  final shouldDelete = await _confirmDelete(context);
                  if (shouldDelete == true) {
                    _deleteEntry(docId);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () => _navigateToDetail(context, data, docId),
              ),
            ],
          ),
          onTap: () => _navigateToDetail(context, data, docId),
        ),
      ),
    );
  }

  void _navigateToDetail(
    BuildContext context,
    Map<String, dynamic> data,
    String docId,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryDetailPage(entry: data, documentId: docId),
      ),
    );
  }

  Widget _buildUserNotLoggedIn() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You need to log in first'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentUser == null) {
      return _buildUserNotLoggedIn();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.rightFromBracket,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => _signOut(context),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        title: const Text(
          'Your Diary Entries',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'my_2',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewEntry(context),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: kToolbarHeight + MediaQuery.of(context).padding.top,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileSection(),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Text(
                    'Recent Entries',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: _buildEntryList()),
            ],
          ),
        ),
      ),
    );
  }
}
