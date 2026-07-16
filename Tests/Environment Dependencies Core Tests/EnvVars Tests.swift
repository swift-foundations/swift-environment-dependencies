//
//  EnvVars Tests.swift
//  swift-environment-dependencies
//

import Dependencies_Test_Support
import Logging
import Testing

@testable import Environment_Dependencies_Core

extension EnvVars {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension EnvVars.Test.Unit {
    @Test
    func `dictionary storage and scalar accessors`() throws {
        var envVars = try EnvVars(
            dictionary: [
                "PORT": "8080",
                "CANONICAL_HOST": "example.com",
                "EMERGENCY_MODE": "1",
                "HTTPS_REDIRECT": "true",
                "LOG_LEVEL": "debug",
                "LOCAL-SSL-SERVER-CRT": "certificate",
                "LOCAL-SSL-SERVER-KEY": "private-key",
                "APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION": "association",
                "TAXIDENTIFICATIONNUMBER": "NL123",
            ],
            requiredKeys: ["PORT"]
        )

        #expect(try envVars.port() == 8080)
        #expect(envVars.canonicalHost == "example.com")
        #expect(envVars.emergencyMode)
        #expect(envVars.httpsRedirect == true)
        #expect(envVars.logLevel == .debug)
        #expect(envVars.localSslServerCrt == "certificate")
        #expect(envVars.localSslServerKey == "private-key")
        #expect(envVars.appleDeveloperMerchantIdDomainAssociation == "association")
        #expect(envVars.taxIdentificationNumber == "NL123")

        envVars.setPort(3000)
        envVars.canonicalHost = nil
        envVars.emergencyMode = false
        envVars.httpsRedirect = false
        envVars.logLevel = .info
        envVars.localSslServerCrt = nil
        envVars.localSslServerKey = nil
        envVars.appleDeveloperMerchantIdDomainAssociation = nil
        envVars.taxIdentificationNumber = nil

        #expect(envVars["PORT"] == "3000")
        #expect(envVars["CANONICAL_HOST"] == nil)
        #expect(envVars["EMERGENCY_MODE"] == "0")
        #expect(envVars["HTTPS_REDIRECT"] == "false")
        #expect(envVars["LOG_LEVEL"] == "info")
        #expect(envVars["LOCAL-SSL-SERVER-CRT"] == nil)
        #expect(envVars["LOCAL-SSL-SERVER-KEY"] == nil)
        #expect(envVars["APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION"] == nil)
        #expect(envVars["TAXIDENTIFICATIONNUMBER"] == nil)
    }

    @Test
    func `legacy type name remains an alias`() {
        let environment: EnvironmentVariables = EnvVars(["KEY": "value"])
        #expect(environment["KEY"] == "value")
    }

    @Test
    func `Foundation-free package fixture remains available`() {
        #expect(EnvVars.localWebDevelopment["APP_ENV"] == "testing")
        #expect(Set<String>.requiredKeys == ["APP_SECRET", "APP_ENV", "BASE_URL", "PORT"])
    }
}

extension EnvVars.Test.`Edge Case` {
    @Test
    func `missing required key throws`() {
        #expect(throws: EnvVarsError.self) {
            try EnvVars(dictionary: [:], requiredKeys: ["REQUIRED"])
        }
    }

    @Test
    func `invalid port throws`() {
        let envVars = EnvVars(["PORT": "not-an-integer"])
        #expect(throws: EnvVarsError.self) {
            try envVars.port()
        }
    }

    @Test
    func `optional and boolean edge values retain legacy semantics`() {
        var envVars = EnvVars([
            "EMERGENCY_MODE": "true",
            "HTTPS_REDIRECT": "anything-other-than-true",
            "LOG_LEVEL": "not-a-level",
        ])

        #expect(!envVars.emergencyMode)
        #expect(envVars.httpsRedirect == false)
        #expect(envVars.logLevel == nil)

        envVars["HTTPS_REDIRECT"] = nil
        #expect(envVars.httpsRedirect == nil)
    }
}

extension EnvVars.Test.Integration {
    @Test
    func `process-only live construction and dependency key compile`() throws {
        let live = try EnvVars.live()

        withDependencies {
            $0.envVars = live
        } operation: {
            @Dependency(\.envVars) var envVars
            #expect(envVars.storage == live.storage)
        }
    }
}
