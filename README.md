# Luxe Toast 💎

A high-performance, physics-based notification system featuring holographic shimmers, staggered kinetic entrances, and a futuristic HUD aesthetic.

![Luxe Toast Demo]<img src="https://github.com/DoctorFlutter/luxe_toast/blob/main/assets/demo_gif.gif" width="200" />

## Screenshots 📸

|                                               Success State                                               |                                                Error State                                                |                                                Info State                                                 |
|:---------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------:|
| <img src="https://github.com/DoctorFlutter/luxe_toast/blob/main/assets/screenshot%20(1).jpg" width="200"> | <img src="https://github.com/DoctorFlutter/luxe_toast/blob/main/assets/screenshot%20(2).jpg" width="200"> | <img src="https://github.com/DoctorFlutter/luxe_toast/blob/main/assets/screenshot%20(3).jpg" width="200"> |

## Features 🚀

* **Kinetic Entrance:** Physically snaps open using elastic physics (no boring fades).
* **Holographic Shimmer:** A light beam sweeps across the glass surface.
* **Alive & Breathing:** The toast gently floats up and down while visible.
* **Staggered Animation:** Icon spins, text slides, and progress bar shrinks.
* **Zero Boilerplate:** Call it anywhere without needing a `BuildContext` builder.

## Parameters ⚙️

| Parameter  | Type               | Description                                        | Default              |
|------------|--------------------|----------------------------------------------------|----------------------|
| `title`    | `String`           | The bold header text.                              | `"Notification"`     |
| `message`  | `String`           | The main body text. **(Required)**                 | —                    |
| `color`    | `Color`            | The accent color for glow & border.                | `Colors.tealAccent`  |
| `icon`     | `IconData`         | The icon displayed on the left.                    | `Icons.info`         |
| `duration` | `Duration`         | How long the toast stays visible.                  | `3 seconds`          |
| `position` | `LuxeToastPosition`| Display position: `.top` or `.bottom`.             | `.top`               |

## Installation 💻

```yaml
dependencies:
  luxe_toast: ^0.0.1
```

## Usage 🛠️
Import the package and use the `luxe_toast` widget in your UI.
```dart
import 'package:luxe_toast/luxe_toast.dart';
// ... inside your widget tree
LuxeToast.show(
  context,
  title: "Access Granted",
  message: "Biometric verification successful.",
  color: Colors.cyanAccent,
  icon: Icons.fingerprint,
  position: LuxeToastPosition.top,
  duration: Duration(seconds: 4),
);
```