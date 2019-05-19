//
//  StageView.swift
//  KRTournamentViewDemo
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import UIKit

final class StageView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
    }
}
