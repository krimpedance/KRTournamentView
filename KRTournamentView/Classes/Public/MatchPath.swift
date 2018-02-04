//
//  MatchPath.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

/// `MatchPath` represents the path to a specific match in a tournament.
public struct MatchPath {
    public let layer: Int
    public let number: Int

    public init(layer: Int, number: Int) {
        self.layer = layer
        self.number = number
    }

    public init?(numberOfLayers: Int, index: Int) {
        guard 0 < numberOfLayers else { return nil }
        guard 0 <= index, index <= Int(pow(2, Double(numberOfLayers)) - 2) else { return nil }
        var number = 0
        var value: Double {
            return pow(2, Double(numberOfLayers)) / (pow(2, Double(numberOfLayers)) - Double(index - number))
        }
        while value.truncatingRemainder(dividingBy: 1) != 0 { number += 1 }

        self.init(layer: Int(log2(value) + 1), number: number)
    }
}

// MARK: - Actions ---------------

extension MatchPath {
    /// Get unique index. Index varies by number of tournament layers.
    ///
    /// - Parameter numberOfLayers: Number of layers.
    /// - Returns: Unique index.
    public func getIndex(from numberOfLayers: Int) -> Int {
        return Int(pow(2, Double(numberOfLayers)) * (1 - 1 / pow(2, Double(layer - 1)))) + number
    }
}

// MARK: - Equatable ---------------

extension MatchPath: Equatable {
    public static func == (lhs: MatchPath, rhs: MatchPath) -> Bool {
        return lhs.layer == rhs.layer && lhs.number == rhs.number
    }
}
