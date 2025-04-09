import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Diary Entry Detail Page
class DiaryDetailPage extends StatelessWidget {
  final Map<String, dynamic> entry;
  final String documentId;

  const DiaryDetailPage({
    Key? key,
    required this.entry,
    required this.documentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _deleteEntry(String documentId) async {
      try {
        await FirebaseFirestore.instance
            .collection('diary_entries')
            .doc(documentId)
            .delete();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Entry deleted successfully')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting entry: $e')));
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Delete Entry'),
                      content: Text(
                        'Are you sure you want to delete this diary entry?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteEntry(
                              documentId,
                            ); // Changed from doc.id to documentId
                          },
                          child: Text('DELETE'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
        title: Text('Diary Entry'),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.png'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                entry['emoji'] ?? '📝',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    fontFamily: 'my',
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  DateFormat('MMMM dd, yyyy').format(
                                    (entry['date'] as Timestamp).toDate(),
                                  ),
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 32),
                      Text(
                        entry['content'] ?? 'No content',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// New Entry Form
class NewEntryPage extends StatefulWidget {
  final String userId;

  const NewEntryPage({Key? key, required this.userId}) : super(key: key);

  @override
  _NewEntryPageState createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedEmoji = '📝';
  bool _isLoading = false;

  final List<String> _emojiOptions = [
    '😊',
    '😢',
    '😍',
    '😎',
    '🥳',
    '😴',
    '🏃',
    '🌧️',
    '☀️',
    '🎉',
    '📚',
    '🍔',
    '💼',
    '🎮',
    '🎵',
    '📝',
    '❤️',
    '🤔',
  ];

  void _saveEntry() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a title')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('diary_entries').add({
        'userId': widget.userId,
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'emoji': _selectedEmoji,
        'date': Timestamp.now(),
      });

      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving entry: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Diary Entry'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _isLoading ? null : _saveEntry,
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Mood',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _emojiOptions.length,
                        itemBuilder: (context, index) {
                          final emoji = _emojiOptions[index];
                          final isSelected = emoji == _selectedEmoji;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedEmoji = emoji;
                              });
                            },
                            child: Container(
                              width: 50,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.indigo.shade100
                                        : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    isSelected
                                        ? Border.all(
                                          color: Colors.indigo,
                                          width: 2,
                                        )
                                        : null,
                              ),
                              child: Center(
                                child: Text(
                                  emoji,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'What happened today?',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 10,
                    ),
                  ],
                ),
              ),
    );
  }
}

// Main Diary Page
class Diarypage extends StatefulWidget {
  const Diarypage({super.key});

  @override
  State<Diarypage> createState() => _DiarypageState();
}

class _DiarypageState extends State<Diarypage> {
  Future<void> _deleteEntry(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('diary_entries')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Entry deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting entry: $e')));
    }
  }

  late User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    setState(() {
      _currentUser = FirebaseAuth.instance.currentUser;
      _isLoading = false;
    });
  }

  // Add this function in the _DiarypageState class

  Future<void> _signOut(BuildContext context) async {
    // Store the context in a local variable to avoid issues with widget disposal
    final navigatorContext = context;

    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      // Use the stored context for navigation
      if (navigatorContext.mounted) {
        Navigator.of(navigatorContext).pushReplacementNamed('/');
      }
    } catch (e) {
      // Only show snackbar if context is still valid
      if (navigatorContext.mounted) {
        ScaffoldMessenger.of(
          navigatorContext,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentUser == null) {
      // User not logged in, redirect to login page
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You need to log in first'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.rightFromBracket,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => _signOut(context),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        title: Text(
          'Your Diary Entries',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'my',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewEntry(context),
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: kToolbarHeight + MediaQuery.of(context).padding.top,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
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
                              ? Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.indigo,
                              )
                              : null,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentUser?.displayName ?? 'User',
                            style: TextStyle(
                              color: Colors.indigo.shade800,
                              fontFamily: 'my',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          FutureBuilder<QuerySnapshot>(
                            future:
                                FirebaseFirestore.instance
                                    .collection('diary_entries')
                                    .where(
                                      'userId',
                                      isEqualTo: _currentUser?.uid,
                                    )
                                    .get(),
                            builder: (context, snapshot) {
                              int entryCount = 0;
                              if (snapshot.hasData) {
                                entryCount = snapshot.data!.docs.length;
                              }
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
              ),

              SizedBox(height: 20),

              // Title for the diary list
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
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

              // Diary entries list
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('diary_entries')
                          .where('userId', isEqualTo: _currentUser?.uid)
                          .orderBy('date', descending: true)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
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
                            SizedBox(height: 16),
                            ElevatedButton.icon(
                              icon: Icon(Icons.add),
                              label: Text('Create First Entry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
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

                        return Dismissible(
                          key: Key(doc.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) {
                            return showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text('Delete Entry'),
                                    content: Text(
                                      'Are you sure you want to delete this diary entry?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(
                                              context,
                                            ).pop(false),
                                        child: Text('CANCEL'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () =>
                                                Navigator.of(context).pop(true),
                                        child: Text('DELETE'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          onDismissed: (direction) {
                            _deleteEntry(doc.id);
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
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
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              title: Text(
                                data['title'] ?? 'No Title',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  DateFormat('MMM dd, yyyy').format(date),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: Text('Delete Entry'),
                                              content: Text(
                                                'Are you sure you want to delete this diary entry?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () =>
                                                          Navigator.of(
                                                            context,
                                                          ).pop(),
                                                  child: Text('CANCEL'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _deleteEntry(doc.id);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('DELETE'),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => DiaryDetailPage(
                                                entry: data,
                                                documentId: doc.id,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DiaryDetailPage(
                                          entry: data,
                                          documentId: doc.id,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
