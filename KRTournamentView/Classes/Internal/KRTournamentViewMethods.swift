//
//  KRTournamentViewMethods.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

// MARK: - Layout -------------------

extension KRTournamentView {
    func updateLayout() {
        entrySize = delegate?.entrySize(in: self) ?? Default.entrySize(with: style)

        drawingView.dataStore = self
        firstEntriesView.dataStore = self
        secondEntriesView.dataStore = self

        removeConstraints()

        addSubview(drawingView)
        addSubview(firstEntriesView)
        addSubview(secondEntriesView)

        let sizeAttribute: NSLayoutConstraint.Attribute = style.isVertical ? .width : .height
        let firstAttribute: NSLayoutConstraint.Attribute = style.isVertical ? .left : .top
        let secondAttribute: NSLayoutConstraint.Attribute = style.isVertical ? .right : .bottom
        let commonAttributes: [NSLayoutConstraint.Attribute] = style.isVertical ? [.top, .bottom] : [.left, .right]

        addConstraints(
            NSLayoutConstraint.constraints(from: firstEntriesView, to: self, attributes: commonAttributes + [firstAttribute]) +
            NSLayoutConstraint.constraints(from: secondEntriesView, to: self, attributes: commonAttributes + [secondAttribute]) +
            NSLayoutConstraint.constraints(from: drawingView, to: self, attributes: commonAttributes) +
            [
                NSLayoutConstraint(item: drawingView, attribute: firstAttribute, toItem: firstEntriesView, attribute: secondAttribute, constant: 5),
                NSLayoutConstraint(item: secondEntriesView, attribute: firstAttribute, toItem: drawingView, attribute: secondAttribute, constant: 5)
            ]
        )

        var (firstConstant, secondConstant) = (entriesSpaceWidth, entriesSpaceWidth)
        switch style {
        case .left, .top: secondConstant = 0
        case .right, .bottom: firstConstant = 0
        default: break
        }
        firstEntriesView.addConstraint(NSLayoutConstraint(item: firstEntriesView, attribute: sizeAttribute, constant: firstConstant))
        secondEntriesView.addConstraint(NSLayoutConstraint(item: secondEntriesView, attribute: sizeAttribute, constant: secondConstant))
    }

    func removeConstraints() {
        drawingView.removeFromSuperview()
        firstEntriesView.removeFromSuperview()
        secondEntriesView.removeFromSuperview()

        drawingView.removeConstraints(drawingView.constraints)
        firstEntriesView.removeConstraints(firstEntriesView.constraints)
        secondEntriesView.removeConstraints(secondEntriesView.constraints)
    }

    func checkRotation() {
        let orientation = UIDevice.current.orientation
        if !fixOrientation || self.orientation == orientation { return }

        switch (self.orientation, orientation) {
        case (.portrait, .landscapeLeft), (.landscapeLeft, .portraitUpsideDown),
             (.landscapeRight, .portrait), (.portraitUpsideDown, .landscapeRight):
            style.rotateLeft()

        case (.portrait, .landscapeRight), (.landscapeLeft, .portrait),
             (.landscapeRight, .portraitUpsideDown), (.portraitUpsideDown, .landscapeLeft):
            style.rotateRight()

        case (.portrait, .portraitUpsideDown), (.landscapeLeft, .landscapeRight),
             (.landscapeRight, .landscapeLeft), (.portraitUpsideDown, .portrait):
            style.reverse()

        default: break
        }

        guard [.portrait, .landscapeLeft, .landscapeRight, .portraitUpsideDown].contains(orientation) else { return }

        self.orientation = orientation
        setNeedsLayout()
    }
}

// MARK: - Actions -------------------

extension KRTournamentView {
    func reloadEntries() {
        let maxEntryNumber = Int(pow(2, Double(numberOfLayers)))
        var excludes = [Int]()
        let entries = (0..<maxEntryNumber).compactMap { index -> KRTournamentViewEntry? in
            let entry = (dataSource ?? self).tournamentView(self, entryAt: index)
            if entry == nil { excludes.append(index) }
            entry?.index = index
            entry?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectEntry(sender:))))
            return entry
        }

        self.excludes = excludes

        switch style {
        case .left, .top:
            firstEntriesView.entries = entries
            secondEntriesView.entries = []
        case .right, .bottom:
            firstEntriesView.entries = []
            secondEntriesView.entries = entries
        case .leftRight, .topBottom:
            firstEntriesView.entries = entries.filter { $0.index < maxEntryNumber / 2 }
            secondEntriesView.entries = entries.filter { $0.index >= maxEntryNumber / 2 }
        }
    }

    func reloadMatches() {
        var matches = [KRTournamentViewMatch]()
        (1...numberOfLayers).forEach { layer in
            let matchNum = Int(pow(2, Double(numberOfLayers - layer)))
            (0..<matchNum).forEach { number in
                switch layer {
                case 1:
                    let homeIndex = 2 * number
                    if excludes.contains(homeIndex) || excludes.contains(homeIndex + 1) { return }

                default:
                    let numberOfEntries = Int(pow(2, Double(layer)))
                    let indexes = (0..<numberOfEntries).map { $0 + (numberOfEntries * number)}
                    let homeIndexes = indexes[0..<indexes.count/2].filter { !excludes.contains($0) }
                    let awayIndexes = indexes.suffix(indexes.count/2).filter { !excludes.contains($0) }
                    if homeIndexes.count == 0 || awayIndexes.count == 0 { return }
                }
                let matchPath = MatchPath(layer: layer, number: number)
                let match = (dataSource ?? self).tournamentView(self, matchAt: matchPath)
                match.matchPath = matchPath
                match.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectMatch(sender:))))
                matches.append(match)
            }
        }
        drawingView.matches = matches
    }

    @objc func didSelectEntry(sender: UITapGestureRecognizer) {
        guard let entry = sender.view as? KRTournamentViewEntry else { return }
        delegate?.tournamentView(self, didSelectEntryAt: entry.index)
    }

    @objc func didSelectMatch(sender: UITapGestureRecognizer) {
        guard let match = sender.view as? KRTournamentViewMatch else { return }
        delegate?.tournamentView(self, didSelectMatchAt: match.matchPath)
    }
}

// MARK: - KRTournamentView data source -------------------

extension KRTournamentView: KRTournamentViewDataSource {
    public func numberOfLayers(in tournamentView: KRTournamentView) -> Int {
        return Default.numberOfLayers
    }

    public func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry? {
        return Default.tournamentViewEntry
    }

    public func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch {
        return Default.tournamentViewMatch
    }
}
