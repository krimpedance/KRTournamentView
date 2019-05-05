//
//  MatchPath.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

/// `MatchPath` represents the path to a specific match in a tournament.
public struct MatchPath {
    public let layer: Int
    public let item: Int

    public init(layer: Int, item: Int) {
        self.layer = layer
        self.item = item
    }
}

// MARK: - Equatable ------------

extension MatchPath: Equatable {
    public static func == (lhs: MatchPath, rhs: MatchPath) -> Bool {
        return lhs.layer == rhs.layer && lhs.item == rhs.item
    }
}
