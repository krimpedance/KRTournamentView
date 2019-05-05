//
//  Defaults.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

struct Default {
    static let style = KRTournamentViewStyle.left
    static let tournamentStructure = TournamentBuilder.build(numberOfLayers: 2)
    static let lineColor = UIColor.black
    static let winnerLineColor = UIColor.red
    static let lineWidth = CGFloat(1.0)
    static let fixOrientation: Bool = false

    static var tournamentViewEntry: KRTournamentViewEntry { return KRTournamentViewEntry() }
    static var tournamentViewMatch: KRTournamentViewMatch { return KRTournamentViewMatch() }

    static func entrySize(with style: KRTournamentViewStyle) -> CGSize {
        return style.isVertical ? CGSize(width: 80, height: 30) : CGSize(width: 30, height: 80)
    }
}
