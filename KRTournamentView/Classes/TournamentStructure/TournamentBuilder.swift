//
//  TournamentBuilder.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import Foundation

/// Builder of `Bracket`
public class TournamentBuilder: Equatable {
    /// Builder Entry
    public enum BuildType: Equatable { case entry, bracket(TournamentBuilder) }

    /// number of winners.
    public var numberOfWinners = 1
    /// Indexes of winning entries.
    public var winnerIndexes = [Int]()
    /// children
    public var children = [BuildType]()

    /// Initializer
    ///
    /// - Parameters:
    ///   - children: array of BuildType.
    ///   - numberOfWinners: number of winners.
    ///   - winnerIndexes: Indexes of winning entries.
    public init(children: [BuildType] = [], numberOfWinners: Int = 1, winnerIndexes: [Int] = []) {
        self.children = children
        self.numberOfWinners = numberOfWinners
        self.winnerIndexes = winnerIndexes
    }

    /// Initialize with symmetrical children.
    ///
    /// - Parameters:
    ///   - numberOfLayers: number of layers.
    ///   - numberOfEntries: number of entries for each bracket.
    ///   - numberOfWinners: number of winners for each bracket.
    ///   - handler: handler returns Indexes of winning entries.
    /// - Returns: TournamentBuilder
    public init(numberOfLayers: Int, numberOfEntries: Int = 2, numberOfWinners: Int = 1, handler: ((MatchPath) -> [Int])? = nil) {
        precondition(numberOfLayers > 0, "numberOfLayers must be greater than 0")
        precondition(numberOfEntries.divisors.contains(numberOfWinners), "numberOfWinners must be divisor of numberOfEntries: \(numberOfEntries) -> \(numberOfEntries.divisors)")

        func innerInit(layer: Int, num: Int) -> TournamentBuilder {
            let winnerIndexes = handler?(.init(layer: layer, item: num)) ?? []
            let children: [BuildType] = {
                switch layer {
                case 1:
                    return (0..<numberOfEntries).map { _ in .entry }
                default:
                    let numberOfChildren = numberOfEntries / numberOfWinners
                    let offset = num * numberOfChildren
                    return (0..<numberOfChildren).map { .bracket(innerInit(layer: layer - 1, num: offset + $0)) }
                }
            }()
            return TournamentBuilder(children: children, numberOfWinners: numberOfWinners, winnerIndexes: winnerIndexes)
        }

        let builder = innerInit(layer: numberOfLayers, num: 0)
        self.numberOfWinners = builder.numberOfWinners
        self.winnerIndexes = builder.winnerIndexes
        self.children = builder.children
    }
}

// MARK: - Public static actions ------------

extension TournamentBuilder {
    public static func == (lhs: TournamentBuilder, rhs: TournamentBuilder) -> Bool {
        return (lhs.numberOfWinners == rhs.numberOfWinners)
            && (lhs.winnerIndexes == rhs.winnerIndexes)
            && (lhs.children == rhs.children)
    }

    /// Build symmetrical bracket.
    ///
    /// - Parameters:
    ///   - numberOfLayers: number of layers.
    ///   - numberOfEntries: number of entries for each bracket.
    ///   - numberOfWinners: number of winners for each bracket.
    ///   - handler: handler returns Indexes of winning entries.
    /// - Returns: formatted Bracket instance
    public static func build(numberOfLayers: Int, numberOfEntries: Int = 2, numberOfWinners: Int = 1, handler: ((MatchPath) -> [Int])? = nil) -> Bracket {
        return TournamentBuilder(numberOfLayers: numberOfLayers, numberOfEntries: numberOfEntries, numberOfWinners: numberOfWinners, handler: handler).build(format: true)
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
        (0..<num).forEach { _ in children.append(.entry) }
        return self
    }

    /// Add `Bracket` to children.
    ///
    /// - Parameter handler: handler returns `TournamentBuilder`.
    /// - Returns: this instance.
    @discardableResult
    func addBracket(_ handler: () -> TournamentBuilder) -> TournamentBuilder {
        children.append(.bracket(handler()))
        return self
    }

    /// Build from currnt state.
    ///
    /// - Parameter format: If true, call `.format()` method after build `Bracket`.
    /// - Returns: this instance.
    func build(format: Bool = false) -> Bracket {
        let structures: [TournamentStructure] = children.map {
            switch $0 {
            case .entry:                return Entry()
            case .bracket(let builder): return builder.build()
            }
        }
        let bracket = Bracket(children: structures, numberOfWinners: numberOfWinners, winnerIndexes: winnerIndexes)
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
