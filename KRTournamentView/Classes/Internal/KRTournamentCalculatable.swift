//
//  KRTournamentCalculatable.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

enum DrawHalf { case first, second }

protocol KRTournamentCalculatable {
    var dataStore: KRTournamentViewDataStore! { get set }

    var half: DrawHalf { get set }
    var maxEntryNumber: Int { get }
    var validEntrySize: CGSize { get }
    var stepSize: CGSize { get }
}

// MARK: - Extension for UIView -------------------

extension KRTournamentCalculatable where Self: UIView {
    var maxEntryNumber: Int {
        return Int(pow(2, Double(dataStore.numberOfLayers)))
    }

    var validEntrySize: CGSize {
        let length = dataStore.style.isVertical ? dataStore.entrySize.height : dataStore.entrySize.width
        let frameLength = dataStore.style.isVertical ? frame.height : frame.width
        let maxLength = frameLength / max(CGFloat(entryNum), 1)

        return dataStore.style.isVertical ?
            CGSize(width: dataStore.entriesSpaceWidth, height: min(length, maxLength)) :
            CGSize(width: min(length, maxLength), height: dataStore.entriesSpaceWidth)
    }

    var stepSize: CGSize {
        let layers = dataStore.style.isHalf ? dataStore.numberOfLayers + 1 : dataStore.numberOfLayers * 2
        return dataStore.style.isVertical ?
            CGSize(
                width: frame.width / CGFloat(layers),
                height: (frame.height - validEntrySize.height) / max(CGFloat(entryNum - 1), 1)
            ) :
            CGSize(
                width: (frame.width - validEntrySize.width) / max(CGFloat(entryNum - 1), 1),
                height: frame.height / CGFloat(layers)
        )
    }
}

// MARK: - Private -------------------

private extension KRTournamentCalculatable {
    var entryNum: Int {
        switch dataStore.style {
        case .leftRight, .topBottom:
            let offset = (half == .first) ? 0 : maxEntryNumber / 2
            return (0..<maxEntryNumber/2).map { $0 + offset }.filter { !dataStore.excludes.contains($0) }.count
        default:
            return maxEntryNumber - dataStore.excludes.count
        }
    }
}
