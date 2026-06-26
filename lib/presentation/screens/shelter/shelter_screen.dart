import 'package:flutter/material.dart';

class ShelterScreen extends StatelessWidget {
  const ShelterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('주변 대피소')),
      body: const Center(
        child: Text('대피소 화면 — Phase 4에서 구현'),
      ),
    );
  }
}
