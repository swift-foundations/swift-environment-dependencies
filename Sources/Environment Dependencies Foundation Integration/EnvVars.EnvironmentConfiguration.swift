//
//  EnvVars.EnvironmentConfiguration.swift
//  swift-environment-dependencies
//
//  Describes where `EnvVars.live(environmentConfiguration:)` should look for a
//  dotenv environment file to overlay on top of the live process environment.
//

import Environment
public import Environment_Dependencies_Core
public import Foundation

extension EnvVars {
    /// Selects the dotenv environment file to overlay when building a live `EnvVars`.
    public enum EnvironmentConfiguration: Sendable {
        /// Load `.env.<environment>` (falling back to `.env`) from the given project root.
        case projectRoot(Foundation.URL, environment: Swift.String?)
        /// Load a specific dotenv environment file.
        case localEnvFile(Foundation.URL)
    }
}

extension EnvVars.EnvironmentConfiguration {
    /// Resolves and decodes the dotenv environment file for this configuration, if one exists.
    ///
    /// Returns `nil` when no matching file is present, so callers fall back to the
    /// live process environment alone.
    func load() -> [Swift.String: Swift.String]? {
        let url: Foundation.URL?
        switch self {
        case .localEnvFile(let file):
            url = file
        case .projectRoot(let root, let environment):
            let candidates = environment.map { [".env.\($0)", ".env"] } ?? [".env"]
            url =
                candidates
                .map { root.appendingPathComponent($0) }
                .first { FileManager.default.fileExists(atPath: $0.path) }
        }
        // swift-linter:disable:next try optional
        // REASON: Foundation.Data(contentsOf:) is an untyped cross-module throwing API.
        guard let url, let data = try? Data(contentsOf: url) else { return nil }
        let text = Swift.String(decoding: data, as: Swift.UTF8.self)
        do throws(Environment.Dotenv.Error) {
            return try Environment.Dotenv(parsing: text).values
        } catch {
            return nil
        }
    }
}
