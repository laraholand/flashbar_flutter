# Flashbar for Flutter

A highly customizable and versatile notification widget for Flutter, designed to display informative messages, alerts, and interactive dialogs at the top or bottom of your screen.

`Flashbar` is easy to integrate and offers a rich set of features to match your app's design and functionality needs, from simple notifications to complex user interactions with multiple actions.

## Features

- **Top or Bottom Placement**: Display flashbars at the top or bottom of the screen using the `gravity` property.
- **Custom Content**: Go beyond title and message. Use the `content` property to display any widget for a fully custom layout.
- **Multiple Actions**: Supports both a `primaryAction` and a `secondaryAction`, perfect for confirmation dialogs (e.g., Confirm/Cancel).
- **Auto-Dismiss or Persistent**: Flashbars can automatically dismiss after a specified `duration` or remain on-screen (`persistent`) until dismissed programmatically.
- **Programmatic Control**: Use a `FlashbarController` to dismiss flashbars from anywhere in your code.
- **Swipe to Dismiss**: Enable `enableSwipeToDismiss` to allow users to swipe the flashbar away.
- **Rich Customization**:
    - Add an `icon` for visual context.
    - Customize `backgroundColor`, `titleTextStyle`, `messageTextStyle`, and `shadows`.
    - Adjust `padding`, `margin`, and `borderRadius` for the perfect fit.
- **Status Callbacks**: Use `onStatusChanged` to listen for changes in the flashbar's state (`showing`, `shown`, `dismissing`, `dismissed`).

## Live Demo

See the Flashbar in action [here](https://laraholand.github.io/flashbar_flutter/).

## Installation

Since this is a local library, you can place the `lib/flashbar.dart` file directly into your project's `lib` folder and import it where needed.

If this were a package on pub.dev, you would add it to your `pubspec.yaml`:

```yaml
dependencies:
  flashbar_flutter: ^1.0.0
```

And then run:
```bash
flutter pub get
```

## How to Use

The primary way to display a flashbar is by calling the `showFlashbar` function.

### Basic Flashbar

Here's a simple example of a flashbar that appears at the top of the screen and disappears after 3 seconds.

```dart
import 'package:flashbar_flutter/flashbar_flutter.dart';

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
```

### Flashbar with Actions

You can add primary and secondary actions, which are perfect for confirmation dialogs.

```dart
ElevatedButton(
  child: const Text('Show Flashbar with Two Actions'),
  onPressed: () {
    late FlashbarController controller;
    controller = showFlashbar(
      context: context,
      persistent: true, // Keep it on screen
      gravity: FlashbarGravity.bottom,
      title: 'Delete File?',
      message: 'Are you sure you want to delete this important file?',
      primaryAction: TextButton(
        onPressed: () {
          // Perform delete action
          print('File deleted!');
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
```

### Flashbar with Custom Content

For complete control over the layout, use the `content` parameter. When you provide `content`, the `title` and `message` parameters are ignored.

```dart
ElevatedButton(
  child: const Text('Show Flashbar with Custom Content'),
  onPressed: () {
    showFlashbar(
      context: context,
      gravity: FlashbarGravity.bottom,
      content: const Row(
        children: [
          Icon(Icons.person, color: Colors.blueAccent),
          SizedBox(width: 8),
          Text('This is a completely custom layout!'),
        ],
      ),
      duration: const Duration(seconds: 4),
    );
  },
),
```

### Full Customization Example

This example demonstrates a fully styled success notification.

```dart
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
      duration: const Duration(seconds: 3),
    );
  },
),
```

## API Reference

### `showFlashbar` Function Parameters

| Parameter              | Type                          | Description                                                                                             |
| ---------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------- |
| `context`              | `BuildContext`                | **Required.** The build context to show the flashbar in.                                                |
| `title`                | `String?`                     | The title text. Ignored if `content` is provided.                                                       |
| `message`              | `String?`                     | The message text. Ignored if `content` is provided. Either `title` or `message` must be set if `content` is null. |
| `content`              | `Widget?`                     | A custom widget to display instead of `title` and `message`.                                            |
| `icon`                 | `Widget?`                     | A widget to display to the left of the content.                                                         |
| `primaryAction`        | `Widget?`                     | The main action widget, typically a `TextButton` or `ElevatedButton`.                                   |
| `secondaryAction`      | `Widget?`                     | The secondary action widget, displayed to the left of the primary action.                               |
| `duration`             | `Duration`                    | How long the flashbar is shown. Defaults to 3 seconds. Set `persistent` to `true` to ignore.            |
| `gravity`              | `FlashbarGravity`             | Determines if the flashbar appears at the `top` or `bottom`. Defaults to `bottom`.                      |
| `backgroundColor`      | `Color?`                      | The background color of the flashbar.                                                                   |
| `titleTextStyle`       | `TextStyle?`                  | The style for the title text.                                                                           |
| `messageTextStyle`     | `TextStyle?`                  | The style for the message text.                                                                         |
| `shadows`              | `List<BoxShadow>?`            | A list of shadows to apply to the flashbar.                                                             |
| `padding`              | `EdgeInsets`                  | The padding inside the flashbar. Defaults to `EdgeInsets.all(16.0)`.                                    |
| `margin`               | `EdgeInsets`                  | The margin around the flashbar. Defaults to `EdgeInsets.all(8.0)`.                                      |
| `borderRadius`         | `BorderRadius?`               | The border radius of the flashbar. Defaults to `BorderRadius.circular(8)`.                              |
| `onTap`                | `VoidCallback?`               | A callback that is fired when the flashbar is tapped.                                                   |
| `onStatusChanged`      | `Function(FlashbarStatus)?`   | A callback that reports the status of the flashbar.                                                     |
| `persistent`           | `bool`                        | If `true`, the flashbar will not auto-dismiss. Defaults to `false`.                                     |
| `enableSwipeToDismiss` | `bool`                        | If `true`, the flashbar can be swiped away. Defaults to `false`.                                        |
| `controller`           | `FlashbarController?`         | An optional controller to programmatically dismiss the flashbar.                                        |

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue. If you want to contribute code, please open a pull request.

## License

This project is licensed under the MIT License.