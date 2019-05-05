//
//  KRTournamentEntriesView.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

final class KRTournamentEntriesView: UIView {
    private weak var dataStore: KRTournamentViewDataStore!
    private var drawHalf: DrawHalf!
    private var info: TournamentInfo!

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

        info = TournamentInfo(
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

        entries.enumerated().forEach { index, view in
            var origin: CGPoint
            if dataStore.style.isVertical {
                origin = CGPoint(x: 0, y: info.stepSize.height * CGFloat(index))
                if entries.count == 1 {
                    origin.y = (frame.height - info.entrySize.height) / 2
                }
            } else {
                origin = CGPoint(x: info.stepSize.width * CGFloat(index), y: 0)
                if entries.count == 1 {
                    origin.x = (frame.width - info.entrySize.width) / 2
                }
            }

            view.frame = CGRect(origin: origin, size: info.entrySize)
            addSubview(view)
        }
    }
}
