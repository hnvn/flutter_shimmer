# Test coverage

Line coverage is collected with Flutter's built-in reporter and published to
[Codecov](https://codecov.io/gh/hnvn/flutter_shimmer) from GitHub Actions.

## Local

```bash
flutter test --coverage
python3 tool/coverage_summary.py
```

`flutter test --coverage` writes `coverage/lcov.info` (gitignored). Optional
HTML:

```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## CI

`.github/workflows/flutter.yml`:

1. Runs `flutter test --coverage`.
2. Prints a file table and writes it to the GitHub Actions job summary.
3. Uploads `coverage/lcov.info` to Codecov (`codecov-action@v5`).
4. Stores the lcov file as a workflow artifact.

## Codecov token

Public repos can often upload without a token. If the upload step is skipped or
fails, add a repository secret:

1. Open [Codecov](https://codecov.io) and add `hnvn/flutter_shimmer`.
2. Copy the upload token.
3. GitHub → **Settings → Secrets and variables → Actions → New repository secret**
   named `CODECOV_TOKEN`.

The workflow uses `fail_ci_if_error: false`, so a missing token does not fail
the unit-test job.

## Badge / API

README uses Codecov's badge API:

```
https://codecov.io/gh/hnvn/flutter_shimmer/graph/badge.svg
```

JSON for the default branch:

```
https://codecov.io/api/gh/hnvn/flutter_shimmer
```

The badge shows `unknown` until the first successful upload.
