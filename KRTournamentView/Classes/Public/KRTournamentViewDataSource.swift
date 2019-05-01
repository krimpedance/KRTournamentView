//
//  KRTournamentViewDataSource.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

/// This protocol represents the data model object. as such, it supplies no information about appearance (including the entries and matches)
public protocol KRTournamentViewDataSource: class {
    func structure(of tournamentView: KRTournamentView) -> Bracket

    /// Entry display.
    ///
    /// - Parameters:
    ///   - tournamentView: The tournament view.
    ///   - index: Entry index.
    /// - Returns: KRTournamentViewEntry instance or nil.
    func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry

    /// Match display.
    ///
    /// - Parameters:
    ///   - tournamentView: The tournament view.
    ///   - matchPath: layer and number of the match.
    /// - Returns: KRTournamentViewMatch instance.
    func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch
}
