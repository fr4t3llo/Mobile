// agenda_page.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:diary_app/details.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  bool _isLoading = true;
  List<Map<String, dynamic>> _selectedDayEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchEntriesAndProcessEvents();
  }

  Future<void> _fetchEntriesAndProcessEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      // Fetch all diary entries for the current user
      final querySnapshot =
          await _firestore
              .collection('diary_entries')
              .where('userId', isEqualTo: user.uid)
              .orderBy('date', descending: true)
              .get();

      Map<DateTime, List<Map<String, dynamic>>> tempEvents = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        final dateWithoutTime = DateTime(date.year, date.month, date.day);

        // Add document ID to data for later use
        final entryWithId = Map<String, dynamic>.from(data);
        entryWithId['id'] = doc.id;

        if (tempEvents[dateWithoutTime] != null) {
          tempEvents[dateWithoutTime]!.add(entryWithId);
        } else {
          tempEvents[dateWithoutTime] = [entryWithId];
        }
      }

      setState(() {
        _events = tempEvents;
        _isLoading = false;
        _updateSelectedDayEvents();
      });
    } catch (e) {
      debugPrint('Error fetching entries: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateSelectedDayEvents() {
    final selectedDateKey = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );

    setState(() {
      _selectedDayEvents = _events[selectedDateKey] ?? [];
    });
  }

  Future<void> _deleteEntry(String documentId) async {
    try {
      await _firestore.collection('diary_entries').doc(documentId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry deleted successfully')),
      );

      // Refresh the entries after deletion
      _fetchEntriesAndProcessEvents();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting entry: $e')));
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
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

  void _navigateToDetail(Map<String, dynamic> entry, String documentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DiaryDetailPage(entry: entry, documentId: documentId),
      ),
    ).then((_) {
      // Refresh data when returning from details page
      _fetchEntriesAndProcessEvents();
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final eventDay = DateTime(day.year, day.month, day.day);
    return _events[eventDay] ?? [];
  }

  Widget _buildCalendarSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          eventLoader: _getEventsForDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _updateSelectedDayEvents();
            });
          },
          calendarStyle: CalendarStyle(
            markerDecoration: const BoxDecoration(
              color: Colors.indigo,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.indigo.shade400,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.indigo.shade200,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEntryList() {
    if (_selectedDayEvents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 60,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No entries for ${DateFormat('MMMM d, yyyy').format(_selectedDay)}',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _selectedDayEvents.length,
      itemBuilder: (context, index) {
        final entry = _selectedDayEvents[index];
        final docId = entry['id'];
        final date = (entry['date'] as Timestamp).toDate();

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
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
                  entry['emoji'] ?? '📝',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            title: Text(
              entry['title'] ?? 'No Title',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(date),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                if (entry['content'] != null &&
                    entry['content'].toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      entry['content'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () async {
                final shouldDelete = await _confirmDelete(context);
                if (shouldDelete == true) {
                  _deleteEntry(docId);
                }
              },
            ),
            onTap:
                () => _navigateToDetail(
                  Map<String, dynamic>.from(entry)..remove('id'),
                  docId,
                ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCalendarSection(),
                    const SizedBox(height: 20),
                    Text(
                      DateFormat('MMMM d, yyyy').format(_selectedDay),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildEntryList(),
                  ],
                ),
              ),
    );
  }
}
