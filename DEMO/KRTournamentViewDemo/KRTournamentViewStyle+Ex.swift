//
//  KRTournamentViewStyle+Ex.swift
//  KRTournamentViewDemo
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import UIKit
import KRTournamentView

extension KRTournamentViewStyle {
    static let allItems: [KRTournamentViewStyle] = [.left, .right, .top, .bottom, .leftRight, .topBottom]

    var str: String {
        switch self {
        case .left: return "Left"
        case .right: return "Right"
        case .top: return "Top"
        case .bottom: return "Bottom"
        case .leftRight: return "LeftRight"
        case .topBottom: return "TopBottom"
        }
    }
}
