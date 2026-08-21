public import Dependencies
import Environment

extension EnvVars {

    public static func live() throws(EnvVarsError) -> EnvVars {
        try EnvVars(dictionary: Environment.read.all(), requiredKeys: [])
    }
}

extension EnvVars: Dependency.Key {

    public static var liveValue: EnvVars {
        do throws(EnvVarsError) {
            return try live()
        } catch {
            return EnvVars()
        }
    }
}

extension Dependency.Values {

    public var envVars: EnvVars {
        get { self[EnvVars.self] }
        set { self[EnvVars.self] = newValue }
    }
}
