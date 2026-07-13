//
//  EnvVars.TestSupport.swift
//  swift-environment-dependencies
//
//  Development/test fixtures, moved from swift-server-foundation
//  (decomposition W3, concern C8).
//

import Foundation

extension EnvVars {
    package static var localWebDevelopment: EnvVars {
        try! EnvVars(
            dictionary: [
                "APP_ENV": "testing",
                "APP_SECRET": "test_secret",
                "BASE_URL": "http://localhost:8080",
                "PORT": "8080",
                "GITHUB_CLIENT_ID": "test_github_id",
                "GITHUB_CLIENT_SECRET": "test_github_secret",
                "MAILGUN_BASE_URL": "https://api.mailgun.net",
                "MAILGUN_PRIVATE_API_KEY": "test_mailgun_key",
                "MAILGUN_DOMAIN": "test.mailgun.domain",
                "DATABASE_URL": "postgres://test:test@localhost:5432/test_db",
                "STRIPE_ENDPOINT_SECRET": "test_stripe_endpoint_secret",
                "STRIPE_PUBLISHABLE_KEY": "test_stripe_publishable_key",
                "STRIPE_SECRET_KEY": "test_stripe_secret_key",
            ],
            requiredKeys: .localWebDevelopmentEnvVarsRequiredKeys
        )
    }
}

extension Set<String> {
    package static let localWebDevelopmentEnvVarsRequiredKeys: Set<String> = [
        "APP_SECRET",
        "APP_ENV",
        "BASE_URL",
        "PORT",
    ]

    public static let requiredKeys: Set<String> = [
        "APP_SECRET",
        "APP_ENV",
        "BASE_URL",
        "PORT",
    ]
}
