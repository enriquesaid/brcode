# Contributing to brcode

Thank you for your interest in contributing! This is a small Dart package, so contributions are welcome and appreciated.

## Getting Started

1. Fork the repository and clone your fork.
2. Install the [Dart SDK](https://dart.dev/get-dart) (stable channel, `^3.1.5`).
3. Install dependencies:
   ```bash
   dart pub get
   ```
4. Make your changes in a new branch.

## Development

Run the tests:

```bash
dart test
```

Check formatting:

```bash
dart format --output=none --set-exit-if-changed .
```

Analyze the code:

```bash
dart analyze
```

## Submitting a Pull Request

- Keep changes focused. One concern per PR is preferred.
- Update or add tests for any new behavior.
- Make sure `dart test`, `dart format`, and `dart analyze` all pass before opening a PR.
- Briefly describe what changed and why in the PR description.

## Reporting Issues

Use the GitHub issue templates to report bugs or request features. Please include enough detail to reproduce the problem.

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). Please be respectful in all interactions.
