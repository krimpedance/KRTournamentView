//
//  KRTournamentViewDataStore.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import CoreGraphics

protocol KRTournamentViewDataStore: class {
    var style: KRTournamentViewStyle { get set }
    var numberOfLayers: Int { get set }
    var entrySize: CGSize { get set }
    var excludes: [Int] { get set }

    var entriesSpaceWidth: CGFloat { get }
}

extension KRTournamentViewDataStore {
    var entriesSpaceWidth: CGFloat {
        return style.isVertical ? entrySize.width : entrySize.height
    }
}
