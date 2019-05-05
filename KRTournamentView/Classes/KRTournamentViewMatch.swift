//
//  KRTournamentViewMatch.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

/// KRTournamentViewMatch is a view for match of KRTournamentView
open class KRTournamentViewMatch: UIView {
    /// MatchPath in tournament view.
    internal(set) public var matchPath: MatchPath!

    /// Vertexes of winning line
    internal(set) public var winnerPoints: [CGPoint]!

    /// Initializer
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        backgroundColor = .clear
    }
}
