//
//  KRTournamentViewDataSource.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

/// This protocol represents the data model object. as such, it supplies no information about appearance (including the entries and matches)
public protocol KRTournamentViewDataSource: class {
    /// Layer represents height of the tournament bracket.
    ///
    /// - Parameter tournamentView: The tournament view.
    /// - Returns: number of layers.
    func numberOfLayers(in tournamentView: KRTournamentView) -> Int

    /// Entry display.
    /// When not needing entry of the index, you can return nil.
    ///
    /// - Parameters:
    ///   - tournamentView: The tournament view.
    ///   - index: Entry index.
    /// - Returns: KRTournamentViewEntry instance or nil.
    func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry?

    /// Match display.
    ///
    /// - Parameters:
    ///   - tournamentView: The tournament view.
    ///   - matchPath: layer and number of the match.
    /// - Returns: KRTournamentViewMatch instance.
    func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch
}
