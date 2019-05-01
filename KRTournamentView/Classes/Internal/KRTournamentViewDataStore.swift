//
//  KRTournamentViewDataStore.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import CoreGraphics

protocol KRTournamentViewDataStore: class {
    var style: KRTournamentViewStyle { get }
    var tournamentStructure: Bracket { get }
    var entrySize: CGSize { get }
}
