//
//  KRTournamentViewDataStore.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

protocol KRTournamentViewDataStore: class {
    var style: KRTournamentViewStyle { get }
    var tournamentStructure: Bracket { get }
    var entrySize: CGSize { get }
    var lineColor: UIColor { get }
    var winnerLineColor: UIColor { get }
    var lineWidth: CGFloat { get }
    var winnerLineWidth: CGFloat? { get }
}
