public import Dependencies
public import Foundation

public enum ProjectRootKey: Sendable, Dependency.Key.Test {}

extension ProjectRootKey {
    public static let testValue: URL = {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }()
}

extension Dependency.Values {
    public var projectRoot: URL {
        get { self[ProjectRootKey.self] }
        set { self[ProjectRootKey.self] = newValue }
    }
}
