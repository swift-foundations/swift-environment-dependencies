//
//  EnvVars.live.swift
//  swift-environment-dependencies
//
//  Foundation-backed dotenv overlays for EnvVars live construction.
//

import Environment
public import Environment_Dependencies_Core
public import Foundation

extension EnvVars {
    /// Builds an `EnvVars` from the live process environment, overlaying an optional
    /// dotenv environment file (file values take precedence over the process environment).
    public static func live(localEnvFile: Foundation.URL?) throws(EnvVarsError) -> EnvVars {
        var dictionary = Environment.read.all()
        if let localEnvFile {
            // swift-linter:disable:next try optional
            // REASON: Foundation.Data(contentsOf:) is an untyped cross-module throwing API.
            if let data = try? Foundation.Data(contentsOf: localEnvFile) {
                let text = Swift.String(decoding: data, as: Swift.UTF8.self)
                let fileValues: [Swift.String: Swift.String]?
                do throws(Environment.Dotenv.Error) {
                    fileValues = try Environment.Dotenv(parsing: text).values
                } catch {
                    fileValues = nil
                }
                if let fileValues {
                    for (key, value) in fileValues { dictionary[key] = value }
                }
            }
        }
        return try EnvVars(dictionary: dictionary, requiredKeys: [])
    }

    /// Builds an `EnvVars` from the live process environment, overlaying the dotenv
    /// environment file resolved from `configuration` (file values take precedence).
    public static func live(
        environmentConfiguration configuration: EnvironmentConfiguration
    ) throws(EnvVarsError) -> EnvVars {
        var dictionary = Environment.read.all()
        if let fileValues = configuration.load() {
            for (key, value) in fileValues { dictionary[key] = value }
        }
        return try EnvVars(dictionary: dictionary, requiredKeys: [])
    }
}
