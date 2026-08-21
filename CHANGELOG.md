
## 4.0.0

* **BREAKING:** Use the standalone [`material_ui`](https://pub.dev/packages/material_ui) package instead of `package:flutter/material.dart`. Requires Flutter `>=3.44.0` and Dart `^3.12.0`.
* Keep the animation duration in sync when `period` changes, and restart cleanly when `enabled` is toggled back on
* Start infinite loops with `AnimationController.repeat()` instead of a first `forward()` cycle
* Treat `direction` updates as paint work, not layout work
* Expand widget tests for construction, animation, looping, and highlight geometry
* Refresh README, example README, and add `docs/` for architecture and optimization notes
* Remove leftover `lib/main.dart` counter app from the package

## 3.0.0

* upgrade sdk constraint to support Dart 3

## 2.0.0

* stable version of nullsafety

## 2.0.0-nullsafety.0

* mirgrate to nullsafety

## 1.1.2

* fix bug: missing update `ShimmerDirection`

## 1.1.1

* support dynamic `Gradient` according to the application's `Theme`

## 1.1.0

* improved by using `ShaderMaskLayer`

## 1.0.1

* support stop and resume animation

## 1.0.0

* support animation loop control
* the package is stable enough to reach v1.0.0 now

## 0.0.6

* add code document

## 0.0.5
* re-config to support Dart2

## 0.0.4
* update metadata

## 0.0.3
* add `direction` property to allow customizing animation direction
* **BREAKING:** define a new default constructor to allow customizing gradient pattern, the old default construct is renamed to `Shimmer.fromColors`

## 0.0.2
* update metadata

## 0.0.1
* Initial release.
