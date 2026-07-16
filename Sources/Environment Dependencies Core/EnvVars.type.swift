//
//  EnvVars.type.swift
//  swift-environment-dependencies
//
//  The dictionary-backed environment-variable value type formerly vended by
//  the (now superseded) swift-environment-variables package, moved here from
//  swift-server-foundation (decomposition W3, concern C8). It is owned here
//  so the legacy module surface (`EnvVars` / `EnvironmentVariables`, its
//  subscript, dictionary initializer, `.live(...)`, and the `\.envVars`
//  dependency) is preserved for downstream consumers. Live process-environment
//  access is delegated to the institute `Environment` package
//  (see EnvVars.live.swift).
//

/// A mutable, dictionary-backed snapshot of environment variables.
public struct EnvVars: Sendable {
    /// The underlying key/value store.
    public var storage: [String: String]

    /// Creates an `EnvVars` wrapping the given key/value store.
    public init(_ storage: [String: String] = [:]) {
        self.storage = storage
    }

    /// Creates an `EnvVars` from a dictionary, validating that every required key is present.
    ///
    /// - Throws: ``EnvVarsError/missingVariable(_:)`` for the first required key that is absent.
    public init(dictionary: [String: String], requiredKeys: Set<String>) throws {
        for key in requiredKeys where dictionary[key] == nil {
            throw EnvVarsError.missingVariable(key)
        }
        self.storage = dictionary
    }

    /// Reads or writes the value for a given variable name.
    public subscript(_ name: String) -> String? {
        get { storage[name] }
        set { storage[name] = newValue }
    }
}

/// The name under which this value type was historically imported by downstream code.
public typealias EnvironmentVariables = EnvVars
