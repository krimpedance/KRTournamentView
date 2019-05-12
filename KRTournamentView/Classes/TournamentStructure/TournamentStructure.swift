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
    private var entries: [Entry] {
        if let entry = self as? Entry { return [entry] }
        if let bracket = self as? Bracket { return bracket.children.flatMap { $0.entries } }
        return []
    }

    func entries(style: KRTournamentViewStyle, drawHalf: DrawHalf) -> [Entry] {
        if let entry = self as? Entry { return [entry] }
        guard let bracket = self as? Bracket else { return [] }

        switch style {
        case .leftRight, .topBottom:
            let count = bracket.children.count
            return (drawHalf == .first)
                ? bracket.children[0..<count/2].flatMap { $0.entries }
                : bracket.children[count/2..<count].flatMap { $0.entries }
        case .left, .top:
            return (drawHalf == .first) ? bracket.children.flatMap { $0.entries } : []
        case .right, .bottom:
            return (drawHalf == .second) ? bracket.children.flatMap { $0.entries } : []
        }
    }
}

// MARK: - Equatable ------------

public func == (lhs: TournamentStructure, rhs: TournamentStructure) -> Bool {
    if case let (lEntry?, rEntry?) = (lhs as? Entry, rhs as? Entry) { return lEntry.index == rEntry.index }
    guard case let (lBracket?, rBracket?) = (lhs as? Bracket, rhs as? Bracket) else { return false }

    var isEqualMatchPath: Bool {
        switch (lBracket.matchPath, rBracket.matchPath) {
        case (nil, nil): return true
        case let (lMP?, rMP?): return lMP == rMP
        default: return false
        }
    }

    return isEqualMatchPath
        && lBracket.children == rBracket.children
        && lBracket.numberOfWinners == rBracket.numberOfWinners
        && lBracket.winnerIndexes == rBracket.winnerIndexes
}

public func != (lhs: TournamentStructure, rhs: TournamentStructure) -> Bool {
    return !(lhs == rhs)
}

public func == (lhs: [TournamentStructure], rhs: [TournamentStructure]) -> Bool {
    if lhs.count != rhs.count { return false }

    for (index, lItem) in lhs.enumerated() where lItem != rhs[index] {
        return false
    }

    return true
}
