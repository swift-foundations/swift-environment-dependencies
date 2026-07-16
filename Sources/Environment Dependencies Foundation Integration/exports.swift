//
//  exports.swift
//  swift-environment-dependencies
//

// Foundation Integration extends Core-owned types, so selecting this leaf product
// also exposes the lower-layer owner module. The reverse edge is forbidden.
@_exported public import Environment_Dependencies_Core
