//
//  KRTournamentViewDataSourceMock.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

final class KRTournamentViewDataSourceMock: KRTournamentViewDataSource {
    var structure: Bracket

    init(structure: Bracket = Default.tournamentStructure) {
        self.structure = structure
    }

    func structure(of tournamentView: KRTournamentView) -> Bracket {
        return structure
    }

    func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry {
        return Default.tournamentViewEntry
    }

    func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch {
        return Default.tournamentViewMatch
    }
}
