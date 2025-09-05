//TODO SAMPLE IMPLEMENTATION

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';

class AddVehicleFormPage extends StatelessWidget {
  final WindowController windowController;
  final Map args;

  const AddVehicleFormPage({
    super.key,
    required this.windowController,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    final plateController = TextEditingController();
    final ownerController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: windowController.close,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (args.isNotEmpty) Text("Args: $args"),
            TextField(
              controller: plateController,
              decoration: const InputDecoration(labelText: 'Plate Number'),
            ),
            TextField(
              controller: ownerController,
              decoration: const InputDecoration(labelText: 'Owner Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //  Implement saving to Firebase or your state management
                windowController.close();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
