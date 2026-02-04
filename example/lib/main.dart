import 'package:flutter/material.dart';
import 'package:flashbar_flutter/flashbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashbar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const FlashbarDemo(),
    );
  }
}

class FlashbarDemo extends StatelessWidget {
  const FlashbarDemo({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashbar Demo'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Show Top Flashbar'),
                  onPressed: () {
                    showFlashbar(
                      context: context,
                      gravity: FlashbarGravity.top,
                      title: 'Hello!',
                      message: 'This is a flashbar from the top.',
                      duration: const Duration(seconds: 3),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  child: const Text('Show Bottom Flashbar with Icon'),
                  onPressed: () {
                    showFlashbar(
                      context: context,
                      gravity: FlashbarGravity.bottom,
                      icon: Icon(Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary),
                      title: 'Did you know?',
                      message:
                          'You can add an icon to the flashbar.',
                    );
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  child: const Text('Flashbar with Action'),
                  onPressed: () {
                  late FlashbarController controller;
                     controller = showFlashbar(
                      context: context,
                      gravity: FlashbarGravity.bottom,
                      title: 'Update Available',
                      message: 'A new version of the app is ready to install.',
                      primaryAction: TextButton(
                        onPressed: () {
                          // Action logic here
                          controller.dismiss();
                        },
                        child: const Text('UPDATE'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  child: const Text('Custom Styled Flashbar'),
                  onPressed: () {
                    showFlashbar(
                      context: context,
                      gravity: FlashbarGravity.top,
                      title: 'Success!',
                      message: 'Your profile has been updated.',
                      backgroundColor: Colors.green.shade600,
                      titleTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      messageTextStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text('Show Swipe-to-Dismiss Flashbar'),
                  onPressed: () {
                    showFlashbar(
                      context: context,
                      gravity: FlashbarGravity.bottom,
                      title: 'Swipe Me!',
                      message: 'You can swipe this flashbar to dismiss it.',
                      enableSwipeToDismiss: true,
                    );
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  child: const Text('Show Persistent Flashbar'),
                  onPressed: () {
                  late FlashbarController controller;
                     controller = showFlashbar(
                      context: context,
                      persistent: true,
                      gravity: FlashbarGravity.bottom,
                      title: 'Confirm Action',
                      message: 'This will remain until you select an action.',
                      primaryAction: TextButton(
                        onPressed: () {
                          // Manually dismiss the flashbar using the controller
                          controller.dismiss();
                        },
                        child: const Text('DISMISS'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  child: const Text('Show Flashbar with Content'),
                  onPressed: () {
                    showFlashbar(
                      context: context,
                      gravity: FlashbarGravity.bottom,
                      content: Row(
                        children: [
                          Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          const Text('A custom content'),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  child: const Text('Show Flashbar with Two Actions'),
                  onPressed: () {
                    late FlashbarController controller;
                    controller = showFlashbar(
                      context: context,
                      persistent: true,
                      gravity: FlashbarGravity.bottom,
                      title: 'Delete File?',
                      message:
                          'Are you sure you want to delete this important file?',
                      primaryAction: TextButton(
                        onPressed: () {
                          // Perform delete action
                          controller.dismiss();
                        },
                        child: const Text('CONFIRM'),
                      ),
                      secondaryAction: TextButton(
                        onPressed: () {
                          controller.dismiss();
                        },
                        child: const Text('CANCEL'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
