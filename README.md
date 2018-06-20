# Shimmer

A package provides an easy way to add shimmer effect in Flutter project

<p>
    <img src="./screenshots/loading_list.gif?raw=true"/>
    <img src="./screenshots/slide_to_unlock.gif?raw=true"/>
</p>

## How to use

```dart
import 'package:shimmer/shimmer.dart';

```

```dart
SizedBox(
  width: 200.0,
  height: 100.0,
  child: Shimmer.fromColors(
    baseColor: Colors.red,
    highlightColor: Colors.yellow,
    child: Text(
      'Shimmer',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 40.0,
        fontWeight:
        FontWeight.bold,
      ),
    ),
  ),
);

```