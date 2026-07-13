# swift-environment-dependencies

![Development Status](https://img.shields.io/badge/status-active--development-orange.svg)

The legacy `EnvVars` environment surface and its `\.envVars` /
`\.projectRoot` dependency keys, backed by the institute
[swift-environment](https://github.com/swift-foundations/swift-environment) reader.

> The environment × dependencies integration package: the dictionary-backed
> `EnvVars` value (formerly `ServerFoundationEnvVars`), its typed getters, and
> the dependency keys that inject it. Live reads delegate to `Environment`;
> this surface exists for consumers not yet migrated onto the native
> `Environment` vocabulary.

## Overview

`import Environment_Dependencies` provides:

| Surface | Description |
|---------|-------------|
| `EnvVars` (alias `EnvironmentVariables`) | Mutable dictionary-backed snapshot of environment variables |
| Typed getters | `baseUrl()`, `port()`, `logLevel`, `canonicalHost`, … |
| `EnvVars.live(...)` | Process environment via institute `Environment`, with optional dotenv overlay |
| `@Dependency(\.envVars)` | The application's environment variables |
| `@Dependency(\.projectRoot)` | The project-root URL key |

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-environment-dependencies.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Environment Dependencies", package: "swift-environment-dependencies")
    ]
)
```

## Quick Start

```swift
import Environment_Dependencies

@Dependency(\.envVars) var envVars
let url = try envVars.baseUrl()
```

Override in tests:

```swift
withDependencies {
    $0.envVars = try! .live(localEnvFile: fixtureURL)
} operation: {
    // envVars resolves to the fixture
}
```

## Migration Status

This package preserves the legacy ssf environment surface verbatim so
consumers keep compiling during the decomposition. New code should prefer the
native [swift-environment](https://github.com/swift-foundations/swift-environment)
vocabulary (`Environment.Read`, `Environment.Snapshot`, `Environment.Dotenv`);
this package's own dissolution path is consumers migrating onto it.

## License

Licensed under the [Apache License, Version 2.0](LICENSE.md).
