//
//  PathSet.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import UIKit

struct PathSet {
    let path: UIBezierPath
    let winnerPath: UIBezierPath

    subscript(needsWinnerPath: Bool) -> UIBezierPath {
        return needsWinnerPath ? winnerPath : path
    }

    init(path: UIBezierPath = .init(), winnerPath: UIBezierPath = .init()) {
        self.path = path
        self.winnerPath = winnerPath
    }

    func append(_ pathSet: PathSet) {
        path.append(pathSet.path)
        winnerPath.append(pathSet.winnerPath)
    }
}
