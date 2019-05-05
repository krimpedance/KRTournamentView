//
//  Entry.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import Foundation

/// `Entry` represents a first entry of tournament like the leaf node in the field of tree structure.
public struct Entry: TournamentStructure, CustomStringConvertible {
    let index: Int!

    /// A textual representation
    public var description: String { return "👤_\(index!)" }

    // Initializers ------------

    init(index: Int) { self.index = index }

    /// Initializer
    public init() { index = nil }
}
