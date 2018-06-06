# Shimmer

A package provides an easy way to add shimmer effect in Flutter project

<img src="./screenshot/shimmer.gif?raw=true"/>

## How to use

```
import 'package:shimmer/shimmer.dart';

```

```
SizedBox(
  width: 200.0,
  height: 100.0,
  child: Shimmer(
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