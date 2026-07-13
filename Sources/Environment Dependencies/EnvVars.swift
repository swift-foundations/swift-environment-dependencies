//
//  EnvVars.swift
//  swift-environment-dependencies
//
//  Typed getters over the EnvVars store, moved from swift-server-foundation
//  (decomposition W3, concern C8).
//

public import Foundation
public import Logging

public enum EnvVarsError: Error, CustomStringConvertible {
    case missingVariable(String)
    case invalidFormat(variable: String, expectedType: String, value: String)

    public var description: String {
        switch self {
        case .missingVariable(let name):
            return "Environment variable '\(name)' is not set"
        case .invalidFormat(let variable, let expectedType, let value):
            return
                "Environment variable '\(variable)' has invalid format. Expected \(expectedType), got: '\(value)'"
        }
    }
}

extension EnvVars {
    // Throwing getters for required environment variables
    public func baseUrl() throws -> URL {
        guard let urlString = self["BASE_URL"] else {
            throw EnvVarsError.missingVariable("BASE_URL")
        }
        guard let url = URL(string: urlString) else {
            throw EnvVarsError.invalidFormat(
                variable: "BASE_URL",
                expectedType: "URL",
                value: urlString
            )
        }
        return url
    }

    public mutating func setBaseUrl(_ url: URL) {
        self["BASE_URL"] = url.absoluteString
    }

    public func port() throws -> Int {
        guard let portString = self["PORT"] else {
            throw EnvVarsError.missingVariable("PORT")
        }
        guard let port = Int(portString) else {
            throw EnvVarsError.invalidFormat(
                variable: "PORT",
                expectedType: "Int",
                value: portString
            )
        }
        return port
    }

    public mutating func setPort(_ port: Int) {
        self["PORT"] = String(port)
    }
}

extension EnvVars {
    public var allowedInsecureHosts: [String]? {
        get {
            self["ALLOWED_INSECURE_HOSTS"]?.components(separatedBy: ",").map {
                $0.trimmingCharacters(in: .whitespaces)
            }
        }
        set { self["ALLOWED_INSECURE_HOSTS"] = newValue?.joined(separator: ",") }
    }

    public var canonicalHost: String? {
        get { self["CANONICAL_HOST"] }
        set { self["CANONICAL_HOST"] = newValue }
    }

    public var emergencyMode: Bool {
        get { self["EMERGENCY_MODE"] == "1" }
        set { self["EMERGENCY_MODE"] = newValue ? "1" : "0" }
    }

    public var httpsRedirect: Bool? {
        get { self["HTTPS_REDIRECT"].map { $0 == "true" } }
        set { self["HTTPS_REDIRECT"] = newValue.map { $0 ? "true" : "false" } }
    }

    public var logLevel: Logger.Level? {
        get { self["LOG_LEVEL"].flatMap { Logger.Level(rawValue: $0) } }
        set { self["LOG_LEVEL"] = newValue?.rawValue }
    }
}

extension EnvVars {
    public var localSslServerCrt: String? {
        get { self["LOCAL-SSL-SERVER-CRT"] }
        set { self["LOCAL-SSL-SERVER-CRT"] = newValue }
    }

    public var localSslServerKey: String? {
        get { self["LOCAL-SSL-SERVER-KEY"] }
        set { self["LOCAL-SSL-SERVER-KEY"] = newValue }
    }
}

extension EnvVars {
    public var appleDeveloperMerchantIdDomainAssociation: String? {
        get { self["APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION"] }
        set { self["APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION"] = newValue }
    }
}

extension EnvVars {
    public var taxIdentificationNumber: String? {
        get { self["TAXIDENTIFICATIONNUMBER"] }
        set { self["TAXIDENTIFICATIONNUMBER"] = newValue }
    }
}
