//
//  EnvVars Tests.swift
//  swift-environment-dependencies
//

import Dependencies_Test_Support
import Foundation
import Logging
import Testing

@testable import Environment_Dependencies

enum TestError: Error {
    case envExampleNotFound
}

let packageRoot = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()

@Suite(
    "EnvVars Tests",
    .dependencies {
        $0.envVars = try! .live(
            localEnvFile: packageRoot.appendingPathComponent(".env.example")
        )
    }
)
struct EnvVarsTests {

    @Suite("Environment File Integration Tests")
    struct EnvironmentFileIntegrationTests {

        @Test("EnvVars can load from .env.example file")
        func canLoadFromEnvExampleFile() throws {
            @Dependency(\.envVars) var envVars

            // Test that required keys are present
            #expect(envVars["APP_SECRET"] != nil)
            #expect(envVars["APP_ENV"] != nil)
            #expect(envVars["BASE_URL"] != nil)
            #expect(envVars["PORT"] != nil)
        }

        @Test("Base configuration properties work with .env.example")
        func baseConfigurationWithEnvExample() throws {
            @Dependency(\.envVars) var envVars

            #expect(try envVars.baseUrl().absoluteString == "http://localhost:8080")
            #expect(try envVars.port() == 8080)
        }

        @Test("Server configuration properties work with .env.example")
        func serverConfigurationWithEnvExample() throws {
            @Dependency(\.envVars) var envVars

            #expect(envVars.allowedInsecureHosts == ["127.0.0.1", "0.0.0.0", "localhost"])
            #expect(envVars.canonicalHost == "localhost:8080")
            #expect(envVars.emergencyMode == false)  //  EnvVars Tests.swift
            #expect(envVars.httpsRedirect == true)
            #expect(envVars.logLevel == .debug)  //  EnvVars Tests.swift
        }

        @Test("SSL configuration properties work with .env.example")
        func sslConfigurationWithEnvExample() throws {
            @Dependency(\.envVars) var envVars

            #expect(envVars.localSslServerCrt?.contains("BEGIN CERTIFICATE") == true)
            #expect(envVars.localSslServerKey?.contains("BEGIN PRIVATE KEY") == true)
        }

        @Test("Apple configuration properties work with .env.example")
        func appleConfigurationWithEnvExample() throws {
            @Dependency(\.envVars) var envVars

            #expect(
                envVars.appleDeveloperMerchantIdDomainAssociation
                    == "apple-developer-merchantid-domain-association-content"
            )
        }

        @Test("Tax configuration properties work with .env.example")
        func taxConfigurationWithEnvExample() throws {
            @Dependency(\.envVars) var envVars

            #expect(envVars.taxIdentificationNumber == "NL001111111111111")
        }

        @Test("All .env.example values match expected defaults")
        func allEnvExampleValuesMatchExpectedDefaults() throws {
            @Dependency(\.envVars) var envVars


            #expect(try envVars.baseUrl().absoluteString == "http://localhost:8080")
            #expect(try envVars.port() == 8080)
            #expect(envVars.allowedInsecureHosts == ["127.0.0.1", "0.0.0.0", "localhost"])
            #expect(envVars.canonicalHost == "localhost:8080")
            #expect(envVars.emergencyMode == false)
            #expect(envVars.httpsRedirect == true)
            #expect(envVars.logLevel == .debug)
            #expect(envVars.localSslServerCrt?.contains("BEGIN CERTIFICATE") == true)
            #expect(envVars.localSslServerKey?.contains("BEGIN PRIVATE KEY") == true)
            #expect(
                envVars.appleDeveloperMerchantIdDomainAssociation
                    == "apple-developer-merchantid-domain-association-content"
            )
            #expect(envVars.taxIdentificationNumber == "NL001111111111111")
        }

        @Test("env.example contains all expected configuration keys")
        func envExampleContainsExpectedKeys() throws {
            @Dependency(\.envVars) var envVars

            //  EnvVars Tests.swift
            let expectedKeys = [
                "ALLOWED_INSECURE_HOSTS",
                "APP_ENV",
                "APP_SECRET",
                "BASE_URL",
                "CANONICAL_HOST",
                "EMERGENCY_MODE",
                "HTTPS_REDIRECT",
                "LOG_LEVEL",
                "LOCAL-SSL-SERVER-CRT",
                "LOCAL-SSL-SERVER-KEY",
                "PORT",
                "APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION",
                "TAXIDENTIFICATIONNUMBER",
            ]

            for key in expectedKeys {
                #expect(envVars[key] != nil, "Missing key: \(key)")
            }
        }
    }

    @Suite("Base Configuration Tests")
    struct BaseConfigurationTests {

        @Test("BaseUrl getter and setter work correctly")
        func baseUrlGetterAndSetter() throws {
            var envVars = try EnvVars(
                dictionary: ["BASE_URL": "https://example.com"],
                requiredKeys: []
            )


            #expect(try envVars.baseUrl().absoluteString == "https://example.com")

            //  EnvVars Tests.swift
            envVars.setBaseUrl(URL(string: "https://newexample.com")!)
            #expect(envVars["BASE_URL"] == "https://newexample.com")
        }

        @Test("Port getter and setter work correctly")
        func portGetterAndSetter() throws {
            var envVars = try EnvVars(dictionary: ["PORT": "8080"], requiredKeys: [])


            #expect(try envVars.port() == 8080)

            //  EnvVars Tests.swift
            envVars.setPort(3000)
            #expect(envVars["PORT"] == "3000")
        }
    }

    @Suite("Server Configuration Tests")
    struct ServerConfigurationTests {

        @Test("AllowedInsecureHosts getter and setter work correctly")
        func allowedInsecureHostsGetterAndSetter() throws {
            var envVars = try EnvVars(
                dictionary: ["ALLOWED_INSECURE_HOSTS": "localhost,127.0.0.1, example.com"],
                requiredKeys: []
            )


            #expect(envVars.allowedInsecureHosts == ["localhost", "127.0.0.1", "example.com"])

            //  EnvVars Tests.swift
            envVars.allowedInsecureHosts = ["newhost.com", "another.com"]
            #expect(envVars["ALLOWED_INSECURE_HOSTS"] == "newhost.com,another.com")


            envVars.allowedInsecureHosts = nil
            #expect(envVars["ALLOWED_INSECURE_HOSTS"] == nil)
        }

        @Test("AllowedInsecureHosts handles nil value")
        func allowedInsecureHostsHandlesNil() throws {
            let envVars = try EnvVars(dictionary: [:], requiredKeys: [])
            #expect(envVars.allowedInsecureHosts == nil)
        }

        @Test("CanonicalHost getter and setter work correctly")
        func canonicalHostGetterAndSetter() throws {
            var envVars = try EnvVars(
                dictionary: ["CANONICAL_HOST": "example.com"],
                requiredKeys: []
            )

            //  EnvVars Tests.swift
            #expect(envVars.canonicalHost == "example.com")


            envVars.canonicalHost = "newexample.com"
            #expect(envVars["CANONICAL_HOST"] == "newexample.com")

            //  EnvVars Tests.swift
            envVars.canonicalHost = nil
            #expect(envVars["CANONICAL_HOST"] == nil)
        }

        @Test("EmergencyMode getter and setter work correctly")
        func emergencyModeGetterAndSetter() throws {
            var envVars = try EnvVars(dictionary: ["EMERGENCY_MODE": "1"], requiredKeys: [])


            #expect(envVars.emergencyMode == true)

            //  EnvVars Tests.swift
            envVars["EMERGENCY_MODE"] = "0"
            #expect(envVars.emergencyMode == false)


            envVars.emergencyMode = true
            #expect(envVars["EMERGENCY_MODE"] == "1")

            //  EnvVars Tests.swift
            envVars.emergencyMode = false
            #expect(envVars["EMERGENCY_MODE"] == "0")
        }

        @Test("HttpsRedirect getter and setter work correctly")
        func httpsRedirectGetterAndSetter() throws {
            var envVars = try EnvVars(dictionary: ["HTTPS_REDIRECT": "true"], requiredKeys: [])


            #expect(envVars.httpsRedirect == true)

            //  EnvVars Tests.swift
            envVars["HTTPS_REDIRECT"] = "false"
            #expect(envVars.httpsRedirect == false)


            envVars["HTTPS_REDIRECT"] = nil
            #expect(envVars.httpsRedirect == nil)

            //  EnvVars Tests.swift
            envVars.httpsRedirect = true
            #expect(envVars["HTTPS_REDIRECT"] == "true")


            envVars.httpsRedirect = false
            #expect(envVars["HTTPS_REDIRECT"] == "false")

            //  EnvVars Tests.swift
            envVars.httpsRedirect = nil
            #expect(envVars["HTTPS_REDIRECT"] == nil)
        }

        @Test("LogLevel getter and setter work correctly")
        func logLevelGetterAndSetter() throws {
            var envVars = try EnvVars(dictionary: ["LOG_LEVEL": "info"], requiredKeys: [])


            #expect(envVars.logLevel == .info)

            //  EnvVars Tests.swift
            envVars["LOG_LEVEL"] = "invalid"
            #expect(envVars.logLevel == nil)


            envVars["LOG_LEVEL"] = nil
            #expect(envVars.logLevel == nil)

            //  EnvVars Tests.swift
            envVars.logLevel = .debug
            #expect(envVars["LOG_LEVEL"] == "debug")


            envVars.logLevel = nil
            #expect(envVars["LOG_LEVEL"] == nil)
        }

        @Test("SSL certificate properties work correctly")
        func sslCertificateProperties() throws {
            var envVars = try EnvVars(
                dictionary: [
                    "LOCAL-SSL-SERVER-CRT": "cert_content",
                    "LOCAL-SSL-SERVER-KEY": "key_content",
                ],
                requiredKeys: []
            )

            //  EnvVars Tests.swift
            #expect(envVars.localSslServerCrt == "cert_content")
            #expect(envVars.localSslServerKey == "key_content")


            envVars.localSslServerCrt = "new_cert"
            envVars.localSslServerKey = "new_key"
            #expect(envVars["LOCAL-SSL-SERVER-CRT"] == "new_cert")
            #expect(envVars["LOCAL-SSL-SERVER-KEY"] == "new_key")
        }
    }

    @Suite("Apple Configuration Tests")
    struct AppleConfigurationTests {

        @Test("AppleDeveloperMerchantIdDomainAssociation getter and setter work correctly")
        func appleDeveloperMerchantIdDomainAssociation() throws {
            var envVars = try EnvVars(
                dictionary: [
                    "APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION": "association_content"
                ],
                requiredKeys: []
            )

            //  EnvVars Tests.swift
            #expect(envVars.appleDeveloperMerchantIdDomainAssociation == "association_content")


            envVars.appleDeveloperMerchantIdDomainAssociation = "new_association"
            #expect(envVars["APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION"] == "new_association")

            //  EnvVars Tests.swift
            envVars.appleDeveloperMerchantIdDomainAssociation = nil
            #expect(envVars["APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION"] == nil)
        }
    }

    @Suite("Tax Configuration Tests")
    struct TaxConfigurationTests {

        @Test("TaxIdentificationNumber getter and setter work correctly")
        func taxIdentificationNumber() throws {
            var envVars = try EnvVars(
                dictionary: ["TAXIDENTIFICATIONNUMBER": "123456789"],
                requiredKeys: []
            )


            #expect(envVars.taxIdentificationNumber == "123456789")

            //  EnvVars Tests.swift
            envVars.taxIdentificationNumber = "987654321"
            #expect(envVars["TAXIDENTIFICATIONNUMBER"] == "987654321")


            envVars.taxIdentificationNumber = nil
            #expect(envVars["TAXIDENTIFICATIONNUMBER"] == nil)
        }
    }

    @Suite("Predefined Configuration Tests")
    struct PredefinedConfigurationTests {

        @Test("LocalWebDevelopment configuration has correct values")
        func localWebDevelopmentConfiguration() {
            let envVars = EnvVars.localWebDevelopment

            //  EnvVars Tests.swift
            #expect(envVars["APP_ENV"] == "testing")
            #expect(envVars["APP_SECRET"] == "test_secret")
            #expect(envVars["BASE_URL"] == "http://localhost:8080")
            #expect(envVars["PORT"] == "8080")


            #expect(envVars["GITHUB_CLIENT_ID"] == "test_github_id")
            #expect(envVars["GITHUB_CLIENT_SECRET"] == "test_github_secret")
            #expect(envVars["MAILGUN_BASE_URL"] == "https://api.mailgun.net")
            #expect(envVars["MAILGUN_PRIVATE_API_KEY"] == "test_mailgun_key")
            #expect(envVars["MAILGUN_DOMAIN"] == "test.mailgun.domain")
            #expect(envVars["DATABASE_URL"] == "postgres://test:test@localhost:5432/test_db")
            #expect(envVars["STRIPE_ENDPOINT_SECRET"] == "test_stripe_endpoint_secret")
            #expect(envVars["STRIPE_PUBLISHABLE_KEY"] == "test_stripe_publishable_key")
            #expect(envVars["STRIPE_SECRET_KEY"] == "test_stripe_secret_key")
        }

        @Test("LocalWebDevelopment configuration works with computed properties")
        func localWebDevelopmentComputedProperties() throws {
            let envVars = EnvVars.localWebDevelopment

            //  EnvVars Tests.swift
            #expect(try envVars.baseUrl().absoluteString == "http://localhost:8080")
            #expect(try envVars.port() == 8080)
        }
    }

    @Suite("Required Keys Tests")
    struct RequiredKeysTests {

        @Test("Required keys set contains expected values")
        func requiredKeysSetContainsExpectedValues() {
            let expectedKeys: Set<String> = ["APP_SECRET", "APP_ENV", "BASE_URL", "PORT"]
            #expect(Set<String>.requiredKeys == expectedKeys)
        }
    }

    @Suite("Edge Cases Tests")
    struct EdgeCasesTests {

        @Test("Empty string values are handled correctly")
        func emptyStringValues() throws {
            let envVars = try EnvVars(
                dictionary: [
                    "CANONICAL_HOST": "",
                    "ALLOWED_INSECURE_HOSTS": "",
                ],
                requiredKeys: []
            )

            #expect(envVars.canonicalHost == "")

            #expect(envVars.allowedInsecureHosts == [""])

        }

        @Test("Whitespace trimming in allowedInsecureHosts")
        func whitespaceTrimming() throws {
            let envVars = try EnvVars(
                dictionary: ["ALLOWED_INSECURE_HOSTS": " host1 , host2 , host3 "],
                requiredKeys: []
            )
            #expect(envVars.allowedInsecureHosts == ["host1", "host2", "host3"])
        }

        @Test("EmergencyMode handles non-1 values as false")
        func emergencyModeHandlesNonOneValues() throws {
            var envVars = try EnvVars(dictionary: ["EMERGENCY_MODE": "true"], requiredKeys: [])
            #expect(envVars.emergencyMode == false)

            envVars["EMERGENCY_MODE"] = "yes"
            #expect(envVars.emergencyMode == false)

            envVars["EMERGENCY_MODE"] = ""
            #expect(envVars.emergencyMode == false)
        }
    }
}
