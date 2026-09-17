# Mylestography Control Studio (Flutter)

An interactive 3D neomorphic control deck built with Flutter and Dart, demonstrating tactile feedback, state management, and adaptive themes through simulated photography controls.

## Features

- **3D Tactile Buttons**: Dual opposing `BoxShadow` effects and `GestureDetector` callbacks create responsive press and release feedback.
- **Live State Management**: A tap counter, power slider, and status monitor update as users interact with the controls.
- **Adaptive Themes**: Switch between light and dark themes from the app bar.
- **Reusable Components**: The custom `TactileButton` widget manages each control's pressed state independently.
- **Photography Controls**: Shutter, Focus, Burst, and Flash have distinct icons, accent colors, and status messages.
- **Power Feedback and Recharge**: Power above 80% activates a warning background. Holding Recharge restores power to 100%.

## Tech Stack

- **Framework**: Flutter (Material 3)
- **Language**: Dart
- **Key Widgets**: `StatefulWidget`, `GestureDetector`, `AnimatedContainer`, `Slider`, `Wrap`

## Design Decisions

The photography theme connects the control deck to Mylestography. Each button combines a distinct color with an icon and readable label. The controls simulate camera actions through the dashboard. Local pressed state ensures that touching one button does not affect the appearance of the others. A long press distinguishes Recharge from ordinary commands, while the warning background and status message make high power visible in both themes.

## Getting Started

```sh
flutter pub get
flutter run
```

## Validation

```sh
flutter analyze
flutter test
```

The project passed static analysis and all three widget tests. Tests cover pressed state, gesture cancellation, the power threshold, and long-press recharge. Temporary test variants also demonstrate shared-state behavior and reversed shadow directions.

## Screenshots

Captured from the app running on a Pixel 7 Pro Android emulator. The second image shows Shutter held down before release.

![Unpressed controls](https://raw.githubusercontent.com/ozemoya/incl03/main/submission/screenshots/01-unpressed.png)
![Shutter during a press](https://raw.githubusercontent.com/ozemoya/incl03/main/submission/screenshots/02-mid-press.png)

## Assignment Source

Adapted from the instructor's [In-Class Activity 03 starter code](https://codd.cs.gsu.edu/~lhenry23/Web/inc/inc03/v2/index.html).

## GitHub Repository

[ozemoya/incl03](https://github.com/ozemoya/incl03)
