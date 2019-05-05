//
//  KRTournamentViewDelegate.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import CoreGraphics

/// This represents the behaviour of the entries and matches.
public protocol KRTournamentViewDelegate: class {
    // MARK: Layout ------------

    /// Entry size.
    ///
    /// - Parameter tournamentView: the tournament view.
    /// - Returns: CGSize.
    func entrySize(in tournamentView: KRTournamentView) -> CGSize

    // MARK: Selection ------------

    /// Called after the user changes the selection of entry.
    ///
    /// - Parameters:
    ///   - tournamentView: The tournament view.
    ///   - index: Index of selected entry.
    func tournamentView(_ tournamentView: KRTournamentView, didSelectEntryAt index: Int)

    /// Called after the user changes the selection of match.
    ///
    /// - Parameters:
    ///   - tournamentView: The tournament view.
    ///   - matchPath: MatchPath of selected match.
    func tournamentView(_ tournamentView: KRTournamentView, didSelectMatchAt matchPath: MatchPath)
}

// MARK: - Default behavior ------------

public extension KRTournamentViewDelegate {
    func entrySize(in tournamentView: KRTournamentView) -> CGSize {
        return Default.entrySize(with: tournamentView.style)
    }

    func tournamentView(_ tournamentView: KRTournamentView, didSelectEntryAt index: Int) {}
    func tournamentView(_ tournamentView: KRTournamentView, didSelectMatchAt matchPath: MatchPath) {}
}
