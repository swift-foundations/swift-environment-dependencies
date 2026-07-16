//
//  EnvVars.live.swift
//  swift-environment-dependencies
//
//  Live `EnvVars` construction and swift-dependencies integration. The process
//  environment is read through the institute `Environment` package, replacing the
//  superseded swift-environment-variables reader.
//

public import Dependencies
import Environment

extension EnvVars {
    /// Builds an `EnvVars` from the live process environment.
    public static func live() throws -> EnvVars {
        try EnvVars(dictionary: Environment.read.all(), requiredKeys: [])
    }
}

extension EnvVars: Dependency.Key {
    /// The live value reads the current process environment via institute `Environment`.
    public static var liveValue: EnvVars {
        (try? live()) ?? EnvVars()
    }
}

extension Dependency.Values {
    /// The application's environment variables.
    public var envVars: EnvVars {
        get { self[EnvVars.self] }
        set { self[EnvVars.self] = newValue }
    }
}
