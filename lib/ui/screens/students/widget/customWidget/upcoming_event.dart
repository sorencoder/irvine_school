import 'package:flutter/material.dart';

Widget upcomingEventsCard(ColorScheme colorScheme) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      leading: Icon(Icons.event_note, size: 35, color: colorScheme.primary),
      title: const Text('School Events'),
      subtitle: const Text('Annual Sports Day on Nov 15'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {/* Navigate to Calendar/Events screen */},
    ),
  );
}
