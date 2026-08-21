public struct EnvVars: Sendable {

    public var storage: [String: String]

    public init(_ storage: [String: String] = [:]) {
        self.storage = storage
    }

    public init(dictionary: [String: String], requiredKeys: Set<String>) throws(EnvVarsError) {
        for key in requiredKeys where dictionary[key] == nil {
            throw EnvVarsError.missingVariable(key)
        }
        self.storage = dictionary
    }
}

extension EnvVars {

    public subscript(_ name: String) -> String? {
        get { storage[name] }
        set { storage[name] = newValue }
    }
}

public typealias EnvironmentVariables = EnvVars
