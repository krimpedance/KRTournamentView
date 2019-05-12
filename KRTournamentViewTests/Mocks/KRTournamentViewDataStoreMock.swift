//
//  KRTournamentViewDataStoreMock.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

final class KRTournamentViewDataStoreMock: KRTournamentViewDataStore {
    var style: KRTournamentViewStyle
    var tournamentStructure: Bracket
    var entrySize: CGSize
    var lineColor: UIColor
    var winnerLineColor: UIColor
    var lineWidth: CGFloat
    var winnerLineWidth: CGFloat?

    init(
        style: KRTournamentViewStyle = .left,
        tournamentStructure: Bracket = TournamentBuilder.build(numberOfLayers: 2),
        entrySize: CGSize = .init(width: 80, height: 30),
        lineColor: UIColor = .black,
        winnerLineColor: UIColor = .red,
        lineWidth: CGFloat = 2,
        winnerLineWidth: CGFloat? = nil
    ) {
        self.style = style
        self.tournamentStructure = tournamentStructure
        self.entrySize = entrySize
        self.lineColor = lineColor
        self.winnerLineColor = winnerLineColor
        self.lineWidth = lineWidth
        self.winnerLineWidth = winnerLineWidth
    }
}
