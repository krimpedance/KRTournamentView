//
//  TournamentStructure.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import UIKit

public protocol TournamentStructure {
}

extension TournamentStructure {
    var children: [TournamentStructure] {
        if let bracket = self as? Bracket { return bracket.children }
        return []
    }

    var depth: Int {
        if let bracket = self as? Bracket { return bracket.children.max { $0.depth < $1.depth}!.depth + 1 }
        return 0
    }

    var entries: [Entry] {
        if let bracket = self as? Bracket { return bracket.entries }
        if let entry = self as? Entry { return [entry] }
        return []
    }

    var descriptions: [String] {
        if let bracket = self as? Bracket { return bracket.descriptions }
        if let entry = self as? Entry { return [entry.description] }
        return []
    }
}

extension TournamentStructure {
    func entries(style: KRTournamentViewStyle, drawHalf: DrawHalf) -> [Entry] {
        switch style {
        case .leftRight, .topBottom:
            let count = children.count
            return (drawHalf == .first)
                ? children[0..<count/2].flatMap { $0.entries }
                : children[count/2..<count].flatMap { $0.entries }
        case .left, .top:
            return (drawHalf == .first) ? children.flatMap { $0.entries } : []
        case .right, .bottom:
            return (drawHalf == .second) ? children.flatMap { $0.entries } : []
        }
    }
}

public struct Bracket: TournamentStructure, CustomStringConvertible {
    let matchPath: MatchPath
    let children: [TournamentStructure]
    let numberOfWinner: Int
    let winnerIndexes: [Int]

    var entries: [Entry] { return children.flatMap { $0.entries } }
    var matchPaths: [MatchPath] {
        let childMatchPathes = children.flatMap { ($0 as? Bracket)?.matchPaths ?? [] }
        return (children.count == 1) ? childMatchPathes : [matchPath] + childMatchPathes
    }

    var descriptions: [String] {
        return ["🔸[\(matchPath.layer)-\(matchPath.number)]"] + children.flatMap { child in
            return child.descriptions.enumerated().map { index, desc in
                return (index == 0)
                    ? " ▹︎ " + desc
                    : "   " + desc
            }
        }
    }

    public var description: String { return descriptions.joined(separator: "\n") }

    init(children: [TournamentStructure], numberOfWinner: Int = 1, winnerIndexes: [Int] = []) {
        let children = children.compactMap { child -> TournamentStructure? in
            if child is Bracket || child is Entry { return child }
            return nil
        }

        precondition(numberOfWinner > 0, "numberOfWinner must be greater than 0")

        self.matchPath = .init(layer: -1, number: -1)
        self.children = children
        self.numberOfWinner = numberOfWinner
        self.winnerIndexes = winnerIndexes
    }

    init(matchPath: MatchPath, children: [TournamentStructure], numberOfWinner: Int = 1, winnerIndexes: [Int] = []) {
        self.matchPath = matchPath
        self.children = children
        self.numberOfWinner = numberOfWinner
        self.winnerIndexes = winnerIndexes
    }

    mutating func format() {
        self = formatted()
    }

    func formatted() -> Bracket {
        let layer = depth
        var entryIndex = 0
        var matchNumbers = [Int: Int]()
        (0...layer).forEach { matchNumbers[$0] = 0 }

        let children = self.children.compactMap { child -> TournamentStructure? in
            if var bracket = child as? Bracket {
                let childLayer = layer - 1
                defer { matchNumbers[childLayer]! += 1 }
                return bracket.formatted(
                    matchPath: .init(layer: childLayer, number: matchNumbers[childLayer]!),
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

        return Bracket(matchPath: .init(layer: layer, number: 0), children: children, numberOfWinner: numberOfWinner, winnerIndexes: winnerIndexes)
    }

    private func formatted(matchPath: MatchPath, matchNumbers: inout [Int: Int], entryIndex: inout Int) -> Bracket {
        let children = self.children.compactMap { child -> TournamentStructure? in
            if var bracket = child as? Bracket {
                let childLayer = matchPath.layer - 1
                defer { matchNumbers[childLayer]! += 1 }
                return bracket.formatted(
                    matchPath: .init(layer: childLayer, number: matchNumbers[childLayer]!),
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

        return .init(matchPath: matchPath, children: children, numberOfWinner: numberOfWinner, winnerIndexes: winnerIndexes)
    }
}

public struct Entry: TournamentStructure, CustomStringConvertible {
    var index: Int = -1

    var children: [TournamentStructure] { return [] }
    var entries: [Entry] { return [self] }

    public var description: String { return "👤_\(index)" }

    // Initializers ------------

    public init(index: Int) { self.index = index }

    public init() {}
}

// MARK: - Builder ------------

extension Bracket {
    public class Builder {
        var children = [TournamentStructure]()
        var numberOfWinners = 1
        var winnerIndexes = [Int]()

        public init(numberOfWinners: Int = 1, winnerIndexes: [Int] = []) {
            self.numberOfWinners = numberOfWinners
            self.winnerIndexes = winnerIndexes
        }

        public func setNumberOfWinners(_ num: Int) -> Builder {
            numberOfWinners = num
            return self
        }

        public func setWinnerIndexes(_ indexes: [Int]) -> Builder {
            winnerIndexes = indexes
            return self
        }

        public func addEntry() -> Builder {
            children.append(Entry())
            return self
        }

        public func addBracket(_ handler: () -> Bracket) -> Builder {
            children.append(handler())
            return self
        }

        public func build(withFormat format: Bool = false) -> Bracket {
            let bracket = Bracket(children: children, numberOfWinner: numberOfWinners, winnerIndexes: winnerIndexes)
            return format ? bracket.formatted() : bracket
        }

        public static func build(numberOfLayers: Int, numberOfEntries: Int = 2, numberOfWinners: Int = 1, handler: ((MatchPath) -> [Int])? = nil) -> Bracket {
            precondition(numberOfLayers > 0, "numberOfLayers must be greater than 0")
            precondition(numberOfEntries.divisors.contains(numberOfWinners), "numberOfWinners must be divisor of numberOfEntries: \(numberOfEntries) -> \(numberOfEntries.divisors)")

            func innerInit(layer: Int, num: Int) -> Bracket {
                switch layer {
                case 1:
                    let offset = num * numberOfEntries
                    let matchPath = MatchPath(layer: layer, number: num)
                    return .init(
                        matchPath: matchPath,
                        children: (0..<numberOfEntries).map { Entry(index: offset + $0) },
                        numberOfWinner: numberOfWinners,
                        winnerIndexes: handler?(matchPath) ?? []
                    )
                default:
                    let numberOfChild = numberOfEntries / numberOfWinners
                    let offset = num * numberOfChild
                    let matchPath = MatchPath(layer: layer, number: num)
                    return .init(
                        matchPath: matchPath,
                        children: (0..<numberOfChild).map { innerInit(layer: layer - 1, num: offset + $0) },
                        numberOfWinner: numberOfWinners,
                        winnerIndexes: handler?(matchPath) ?? []
                    )
                }
            }

            return innerInit(layer: numberOfLayers, num: 0)
        }
    }
}

private extension Int {
    var divisors: [Int] {
        if self < 1 { return [] }
        return (1...Swift.max(1, self/2)).filter { self % $0 == 0 }
    }
}
