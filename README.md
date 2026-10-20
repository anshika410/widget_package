# widget_package

Animated backgrounds and widget animations for Flutter (Android and iOS).

**Features:** animated gradient background, floating bubbles background, wave background, fade-slide entrance, pulse, bounce on tap.

---

## Before you start

You need Flutter 3.27 or newer. Check it by running:

```bash
flutter --version
```

If your version is older, run `flutter upgrade`.

---

## Step 1: Add the package to your project

Open a terminal in your app's project folder (the one containing `pubspec.yaml`) and run:

```bash
flutter pub add widget_package --git-url=https://github.com/anshika410/widget_package.git --git-ref=v0.1.0
```

That's it. The command downloads the package and adds it to your `pubspec.yaml`.

**Prefer to edit the file yourself?** Add this under `dependencies:` in `pubspec.yaml`, lined up with `flutter:`, then run `flutter pub get`:

```yaml
  widget_package:
    git:
      url: https://github.com/anshika410/widget_package.git
      ref: v0.1.0
```

> If the repository is private, you must be signed in to GitHub on your computer with an account that has access.

---

## Step 2: Import it

Add this line at the top of any Dart file where you want to use the features:

```dart
import 'package:widget_package/widget_package.dart';
```

---

## Step 3: Use the features

Copy the snippet for the feature you want and replace `YourContent()` with your own widget.

### Animated gradient background

```dart
AnimatedGradientBackground(
  child: YourContent(),
)
```

### Floating bubbles background

```dart
FloatingBubblesBackground(
  backgroundColor: Colors.indigo,
  child: YourContent(),
)
```

### Wave background

```dart
WaveBackground(
  waveColor: Colors.cyanAccent,
  child: YourContent(),
)
```

### Fade and slide in

```dart
FadeSlideIn(
  child: YourContent(),
)
```

For a staggered list, give each item a bigger delay:

```dart
FadeSlideIn(
  delay: Duration(milliseconds: 200),
  child: YourContent(),
)
```

### Pulse

```dart
Pulse(
  child: YourContent(),
)
```

### Bounce on tap

```dart
BounceTap(
  onTap: () {
    // your action here
  },
  child: YourContent(),
)
```

---

## Full screen example

Create a new screen and paste this to see several features together:

```dart
import 'package:flutter/material.dart';
import 'package:widget_package/widget_package.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        child: Center(
          child: FadeSlideIn(
            child: Pulse(
              child: BounceTap(
                onTap: () {},
                child: const Text(
                  'Hello',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

Then open it from your app, for example by setting it as `home:` in `MaterialApp`:

```dart
MaterialApp(home: const DemoScreen())
```

---

## Step 4: Run your app

```bash
flutter run
```

---

## Tips

- Backgrounds fill all available space. Use them as the `body` of a `Scaffold`.
- To show a background behind a whole screen, wrap the `Scaffold` in the background widget and set the `Scaffold`'s `backgroundColor` to `Colors.transparent`.
- After adding or updating the package, do a full restart of the app, not just hot reload.

---

## Updating to a new version

1. Find the newest version tag on the GitHub repository under **Tags** (for example `v0.1.1`).
2. Change `ref: v0.1.0` in your `pubspec.yaml` to the new tag.
3. Run:
   ```bash
   flutter pub upgrade widget_package
   ```

---

## Problems?

| Problem | Fix |
|---|---|
| "Repository not found" or sign-in error | Make sure you have access to the GitHub repo and are signed in |
| "Version solving failed" | Update Flutter with `flutter upgrade` |
| Widget not found | Check the import line from Step 2 |
| Old behavior after updating | Run `flutter clean`, then `flutter pub get`, then `flutter run` |
