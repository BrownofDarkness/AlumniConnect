import 'package:flutter/material.dart';

class AlumniDetailScreen extends StatelessWidget {
  const AlumniDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Alumni Detail Screen — id: $id'),
      ),
    );
  }
}
