//
//  TournamentBuilder.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import Foundation

/// Builder of `Bracket`
public class TournamentBuilder {
    public private(set) var children = [TournamentStructure]()
    public private(set) var numberOfWinners = 1
    public private(set) var winnerIndexes = [Int]()

    /// Initializer
    ///
    /// - Parameters:
    ///   - numberOfWinners: number of winners.
    ///   - winnerIndexes: Indexes of winning entries.
    public init(numberOfWinners: Int = 1, winnerIndexes: [Int] = []) {
        self.numberOfWinners = numberOfWinners
        self.winnerIndexes = winnerIndexes
    }
}

// MARK: - Public static actions ------------

extension TournamentBuilder {
    /// Build symmetrical bracket.
    ///
    /// - Parameters:
    ///   - numberOfLayers: number of layers.
    ///   - numberOfEntries: number of entries for each bracket.
    ///   - numberOfWinners: number of winners for each bracket.
    ///   - handler: handler returns Indexes of winning entries.
    /// - Returns: built Bracket instance
    public static func build(numberOfLayers: Int, numberOfEntries: Int = 2, numberOfWinners: Int = 1, handler: ((MatchPath) -> [Int])? = nil) -> Bracket {
        precondition(numberOfLayers > 0, "numberOfLayers must be greater than 0")
        precondition(numberOfEntries.divisors.contains(numberOfWinners), "numberOfWinners must be divisor of numberOfEntries: \(numberOfEntries) -> \(numberOfEntries.divisors)")

        func innerInit(layer: Int, num: Int) -> Bracket {
            switch layer {
            case 1:
                let offset = num * numberOfEntries
                let matchPath = MatchPath(layer: layer, item: num)
                return .init(
                    matchPath: matchPath,
                    children: (0..<numberOfEntries).map { Entry(index: offset + $0) },
                    numberOfWinners: numberOfWinners,
                    winnerIndexes: handler?(matchPath) ?? []
                )
            default:
                let numberOfChildren = numberOfEntries / numberOfWinners
                let offset = num * numberOfChildren
                let matchPath = MatchPath(layer: layer, item: num)
                return .init(
                    matchPath: matchPath,
                    children: (0..<numberOfChildren).map { innerInit(layer: layer - 1, num: offset + $0) },
                    numberOfWinners: numberOfWinners,
                    winnerIndexes: handler?(matchPath) ?? []
                )
            }
        }

        return innerInit(layer: numberOfLayers, num: 0)
    }
}

// MARK: - Public actions ------------

public extension TournamentBuilder {
    /// Sets number of winners.
    ///
    /// - Parameter num: number of winners.
    /// - Returns: this instance.
    @discardableResult
    func setNumberOfWinners(_ num: Int) -> TournamentBuilder {
        numberOfWinners = num
        return self
    }

    /// Sets indexes of winning entries.
    ///
    /// - Parameter indexes: indexes of winning entries.
    /// - Returns: this instance.
    @discardableResult
    func setWinnerIndexes(_ indexes: [Int]) -> TournamentBuilder {
        winnerIndexes = indexes
        return self
    }

    /// Add `Entry` to children.
    ///
    /// - Parameter num: number of entries to add.
    /// - Returns: this instance.
    @discardableResult
    func addEntry(_ num: Int = 1) -> TournamentBuilder {
        (0..<num).forEach { _ in children.append(Entry()) }
        return self
    }

    /// Add `Bracket` to children.
    ///
    /// - Parameter handler: handler returns `Bracket`.
    /// - Returns: this instance.
    @discardableResult
    func addBracket(_ handler: () -> Bracket) -> TournamentBuilder {
        children.append(handler())
        return self
    }

    /// Build from currnt state.
    ///
    /// - Parameter format: If true, call `.format()` method after build `Bracket`.
    /// - Returns: this instance.
    func build(format: Bool = false) -> Bracket {
        let bracket = Bracket(children: children, numberOfWinners: numberOfWinners, winnerIndexes: winnerIndexes)
        return format ? bracket.formatted() : bracket
    }
}

// MARK: - Extensions ------------

extension Int {
    var divisors: [Int] {
        if self < 1 { return [] }
        return (1...Swift.max(1, self/2)).filter { self % $0 == 0 }
    }
}
