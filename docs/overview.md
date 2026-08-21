# Project overview

Context for working on [`shimmer`](https://pub.dev/packages/shimmer), a Flutter
package that paints a moving highlight over placeholder UI.

## Layout

| Path | Role |
|------|------|
| `lib/shimmer.dart` | Entire public API (`Shimmer`, `ShimmerDirection`, `Shimmer.fromColors`) |
| `test/shimmer_test.dart` | Widget tests plus geometry tests for `shimmerHighlightRect` |
| `example/` | Sample app: loading list and slide-to-unlock |
| `example/lib/placeholders.dart` | Skeleton blocks used by the loading-list demo |

There is no plugin/platform code. Painting is done with a `ShaderMaskLayer`.

## Widget tree

```
Shimmer (StatefulWidget + AnimationController)
  └── AnimatedBuilder
        └── _Shimmer (SingleChildRenderObjectWidget)
              └── _ShimmerFilter (RenderProxyBox)
                    └── ShaderMaskLayer (BlendMode.srcIn)
```

`AnimatedBuilder` receives `child: widget.child` so the placeholder subtree
is not rebuilt every tick. `_ShimmerFilter` only `markNeedsPaint()`s when
`percent`, `gradient`, or `direction` change.

## Public API

- `Shimmer(...)` — caller supplies a `Gradient`.
- `Shimmer.fromColors(...)` — builds a five-stop `LinearGradient` from
  `baseColor` and `highlightColor`.
- `ShimmerDirection` — `ltr`, `rtl`, `ttb`, `btt`.
- `enabled` pauses the ticker; `loop: 0` repeats forever.

Geometry for the sliding highlight is in `shimmerHighlightRect` (marked
`@visibleForTesting`).

## Conventions

- Match the existing style in `lib/shimmer.dart` (explicit types, named
  arguments, short dartdoc on the public widget).
- Keep the public surface small. Do not add new widgets or dependencies
  without an explicit request.
- SDK constraint is `>=2.17.0 <4.0.0`. Avoid Dart 3-only syntax in
  `lib/` (no switch expressions, no records).
