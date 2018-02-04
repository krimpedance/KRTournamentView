//
//  KRTournamentEntriesView.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

class KRTournamentEntriesView: UIView, KRTournamentCalculatable {
    weak var dataStore: KRTournamentViewDataStore!

    var half: DrawHalf = .first

    var entries = [KRTournamentViewEntry]() {
        willSet { entries.forEach { $0.removeFromSuperview() } }
        didSet { updateLayout() }
    }

    convenience init(half: DrawHalf) {
        self.init(frame: .zero)
        self.half = half
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
}

// MARK: - Actions -------------------

private extension KRTournamentEntriesView {
    func updateLayout() {
        entries.enumerated().forEach { index, view in
            view.frame = getEntryFrame(from: index)
            addSubview(view)
        }
    }

    func getEntryFrame(from index: Int) -> CGRect {
        var origin: CGPoint
        if dataStore.style.isVertical {
            origin = CGPoint(x: 0, y: stepSize.height * CGFloat(index))
            if entries.count == 1 {
                origin.y = (frame.height - validEntrySize.height) / 2
            }
        } else {
            origin = CGPoint(x: stepSize.width * CGFloat(index), y: 0)
            if entries.count == 1 {
                origin.x = (frame.width - validEntrySize.width) / 2
            }
        }
        return CGRect(origin: origin, size: validEntrySize)
    }
}
