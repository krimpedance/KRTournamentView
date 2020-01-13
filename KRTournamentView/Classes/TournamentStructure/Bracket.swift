//
//  Bracket.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import Foundation

/// `Bracket` represents a part of tournament like the internal node in the field of tree structure.
public struct Bracket: TournamentStructure, CustomStringConvertible {
    /// `MatchPath`
    public let matchPath: MatchPath!

    /// Child structures.
    public let children: [TournamentStructure]

    /// Number of winners as structure.
    public let numberOfWinners: Int

    /// Indexes of winning entries.
    public let winnerIndexes: [Int]

    /// A textual representation
    public var description: String { return descriptions.joined(separator: "\n") }

    /// Initializer
    ///
    /// - Parameters:
    ///   - children: Child structures.
    ///   - numberOfWinners: number of winners.
    ///   - winnerIndexes: Indexes of winning entries.
    public init(children: [TournamentStructure], numberOfWinners: Int = 1, winnerIndexes: [Int] = []) {
        precondition(numberOfWinners > 0, "numberOfWinner must be greater than 0")

        self.matchPath = nil
        self.children = children.filter { ($0 is Bracket) || ($0 is Entry) }
        self.numberOfWinners = numberOfWinners
        self.winnerIndexes = winnerIndexes
    }
}

// MARK: - Internal actions ------------

extension Bracket {
    init(matchPath: MatchPath, children: [TournamentStructure], numberOfWinners: Int = 1, winnerIndexes: [Int] = []) {
        self.matchPath = matchPath
        self.children = children.filter { ($0 is Bracket) || ($0 is Entry) }
        self.numberOfWinners = numberOfWinners
        self.winnerIndexes = winnerIndexes
    }

    func getMatchPaths() -> [MatchPath] {
        let (entryNum, childMatchPaths) = children.reduce((0, [])) { result, child -> (Int, [MatchPath]) in
            if child is Entry { return (result.0 + 1, result.1) }
            guard let bracket = child as? Bracket else { return result }
            return (result.0 + bracket.numberOfWinners, result.1 + bracket.getMatchPaths())
        }
        return (entryNum == 1) ? childMatchPaths : [matchPath] + childMatchPaths
    }

    func formatted(force: Bool) -> Bracket {
        if !force && matchPath != nil { return self }

        let layer = searchNumberOfLayer()
        var entryIndex = 0
        var matchNumbers = [Int: Int]()
        (0...layer).forEach { matchNumbers[$0] = 0 }

        let children = self.children.compactMap { child -> TournamentStructure? in
            if var bracket = child as? Bracket {
                let childLayer = layer - 1
                defer { matchNumbers[childLayer]! += 1 }
                return bracket.formatted(
                    matchPath: .init(layer: childLayer, item: matchNumbers[childLayer]!),
                    matchNumbers: &matchNumbers,
                    entryIndex: &entryIndex
                )
            }
            if var entry = child as? Entry {
                defer { entryIndex += 1 }
                return Entry(index: entryIndex)
            }
            return nil
        }

        return Bracket(matchPath: .init(layer: layer, item: 0), children: children, numberOfWinners: numberOfWinners, winnerIndexes: winnerIndexes)
    }

    private func formatted(matchPath: MatchPath, matchNumbers: inout [Int: Int], entryIndex: inout Int) -> Bracket {
        let children = self.children.compactMap { child -> TournamentStructure? in
            if var bracket = child as? Bracket {
                let childLayer = matchPath.layer - 1
                defer { matchNumbers[childLayer]! += 1 }
                return bracket.formatted(
                    matchPath: .init(layer: childLayer, item: matchNumbers[childLayer]!),
                    matchNumbers: &matchNumbers,
                    entryIndex: &entryIndex
                )
            }
            if var entry = child as? Entry {
                defer { entryIndex += 1 }
                return Entry(index: entryIndex)
            }
            return nil
        }

        return .init(matchPath: matchPath, children: children, numberOfWinners: numberOfWinners, winnerIndexes: winnerIndexes)
    }
}

// MARK: - Public actions ------------

public extension Bracket {
    /// Validates values, set Bracket.matchPath and Entry.index to all structures.
    mutating func format() {
        self = formatted(force: true)
    }

    /// Validates values, and returns bracket set Bracket.matchPath and Entry.index to all structures.
    func formatted() -> Bracket {
        return formatted(force: true)
    }
}

// MARK: - Private extensions ------------

private extension TournamentStructure {
    var descriptions: [String] {
        if let entry = self as? Entry { return [entry.description] }
        guard let bracket = self as? Bracket else { return [] }

        return ["🔸[\(bracket.matchPath.layer)-\(bracket.matchPath.item)]"] + bracket.children.flatMap { child in
            return child.descriptions.enumerated().map { index, desc in
                return (index == 0)
                    ? " ▹︎ " + desc
                    : "   " + desc
            }
        }
    }

    func searchNumberOfLayer() -> Int {
        guard let bracket = self as? Bracket else { return 0 }
        if bracket.children.count == 0 { return 1 }
        return bracket.children.map { $0.searchNumberOfLayer() }.max()! + 1
    }
}
