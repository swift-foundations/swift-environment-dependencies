//
//  EnvVars.live.swift
//  swift-environment-dependencies
//
//  Live `EnvVars` construction and swift-dependencies integration. The process
//  environment is read through the institute `Environment` package, replacing the
//  superseded swift-environment-variables reader. An optional dotenv environment file
//  is overlaid on top of the process environment (file values win).
//

public import Dependencies
import Environment
public import Foundation

extension EnvVars {
    /// Builds an `EnvVars` from the live process environment, overlaying an optional
    /// dotenv environment file (file values take precedence over the process environment).
    public static func live(localEnvFile: Foundation.URL? = nil) throws -> EnvVars {
        var dictionary = Environment.read.all()
        if let localEnvFile,
            let data = try? Data(contentsOf: localEnvFile),
            let fileValues = try? Environment.Dotenv(parsing: Swift.String(decoding: data, as: Swift.UTF8.self)).values
        {
            for (key, value) in fileValues { dictionary[key] = value }
        }
        return try EnvVars(dictionary: dictionary, requiredKeys: [])
    }

    /// Builds an `EnvVars` from the live process environment, overlaying the dotenv
    /// environment file resolved from `configuration` (file values take precedence).
    public static func live(
        environmentConfiguration configuration: EnvironmentConfiguration
    ) throws -> EnvVars {
        var dictionary = Environment.read.all()
        if let fileValues = configuration.load() {
            for (key, value) in fileValues { dictionary[key] = value }
        }
        return try EnvVars(dictionary: dictionary, requiredKeys: [])
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
