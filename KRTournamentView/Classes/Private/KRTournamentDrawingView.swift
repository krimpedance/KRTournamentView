//
//  KRTournamentDrawingView.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

final class KRTournamentDrawingView: UIView {
    private weak var dataStore: KRTournamentViewDataStore!

    var matches = [KRTournamentViewMatch]() {
        willSet { matches.forEach { $0.removeFromSuperview() } }
    }

    convenience init(dataStore: KRTournamentViewDataStore) {
        self.init(frame: .zero)
        self.dataStore = dataStore
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let pathSet = getPath()

        dataStore.lineColor.setStroke()
        pathSet.path.lineWidth = dataStore.lineWidth
        pathSet.path.lineCapStyle = .square
        pathSet.path.stroke()

        dataStore.winnerLineColor.setStroke()
        pathSet.winnerPath.lineWidth = dataStore.winnerLineWidth ?? dataStore.lineWidth
        pathSet.winnerPath.lineCapStyle = .square
        pathSet.winnerPath.stroke()

        matches.forEach { addSubview($0) }
    }
}

// MARK: - Private actions ------------

private extension KRTournamentDrawingView {
    func getPath() -> PathSet {
        let drawHalf: DrawHalf = {
            switch dataStore.style {
            case .left, .top, .leftRight, .topBottom: return .first
            case .right, .bottom: return .second
            }
        }()

        return dataStore.tournamentStructure.getPath(with: .init(
            structure: dataStore.tournamentStructure,
            style: dataStore.style,
            drawHalf: drawHalf,
            rect: bounds,
            entrySize: dataStore.entrySize
        )) { matchPath, frame, points in
            guard let match = matches.first(where: { $0.matchPath == matchPath }) else { return }
            match.frame = frame
            match.winnerPoints = points
        }
    }
}
