//
//  KRTournamentEntriesView.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

// MARK: - Protocols ------------

protocol EntriesViewTournamentInfoProtocol {
    var entrySize: CGSize { get }
    init(structure: Bracket, style: KRTournamentViewStyle, drawHalf: DrawHalf, rect: CGRect, entrySize: CGSize)
    func entryPoint(at index: Int) -> CGPoint
}

extension TournamentInfo: EntriesViewTournamentInfoProtocol {}

// MARK: - KRTournamentEntriesView ------------

final class KRTournamentEntriesView: UIView {
    private weak var dataStore: KRTournamentViewDataStore!
    private var drawHalf: DrawHalf!
    private var info: EntriesViewTournamentInfoProtocol!

    var tournamentInfoType: EntriesViewTournamentInfoProtocol.Type = TournamentInfo.self    // for test

    var entries = [KRTournamentViewEntry]() {
        willSet { entries.forEach { $0.removeFromSuperview() } }
        didSet { updateLayout() }
    }

    convenience init(dataStore: KRTournamentViewDataStore, drawHalf: DrawHalf) {
        self.init(frame: .zero)
        self.dataStore = dataStore
        self.drawHalf = drawHalf
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        info = tournamentInfoType.init(
            structure: dataStore.tournamentStructure,
            style: dataStore.style,
            drawHalf: drawHalf,
            rect: bounds,
            entrySize: dataStore.entrySize
        )

        updateLayout()
    }
}

// MARK: - Actions ------------

private extension KRTournamentEntriesView {
    func updateLayout() {
        if info == nil { return }

        entries.forEach { entry in
            let point = info.entryPoint(at: entry.index)

            if dataStore.style.isVertical {
                let origin = CGPoint(x: 0, y: point.y - info.entrySize.height / 2)
                entry.frame = CGRect(origin: origin, size: info.entrySize)
            } else {
                let origin = CGPoint(x: point.x - info.entrySize.width / 2, y: 0)
                entry.frame = CGRect(origin: origin, size: info.entrySize)
            }

            addSubview(entry)
        }
    }
}
