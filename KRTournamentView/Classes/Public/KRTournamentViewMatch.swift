//
//  KRTournamentViewMatch.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

/// MatchPreferredSide
///
/// - home: left or top side.
/// - away: right or bottom side.
public enum MatchPreferredSide {
    case home, away
}

/// KRTournamentViewMatch is a view for match of KRTournamentView
open class KRTournamentViewMatch: UIView {
    /// Default is nil. Label will be created if necessary.
    private(set) open lazy var imageView: UIImageView = self.makeImageView()

    /// MatchPath in tournament view.
    internal(set) public var matchPath = MatchPath(layer: 1, number: 0)

    /// Match preferred side.
    public var preferredSide: MatchPreferredSide?

    /// You can change the size while fixing the center of image view.
    public var imageSize = CGSize(width: 10, height: 10) {
        didSet { updateImageViewSize() }
    }

    /// Initializer
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        backgroundColor = .clear
    }
}

// MARK: - Actions -------------------

extension KRTournamentViewMatch {
    func updateImageViewCenter(_ center: CGPoint) {
        if let constraint = constraints.filter({ $0.firstAttribute == .centerX }).first {
            constraint.constant = center.x - self.center.x
        }
        if let constraint = constraints.filter({ $0.firstAttribute == .centerY }).first {
            constraint.constant = center.y - self.center.y
        }
    }
}

// MARK: - Private actions -------------------

private extension KRTournamentViewMatch {
    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .centerX, toItem: self, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .centerY, toItem: self, constant: 0)
        ])

        imageView.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .width, constant: imageSize.width),
            NSLayoutConstraint(item: imageView, attribute: .height, constant: imageSize.height)
        ])

        return imageView
    }

    func updateImageViewSize() {
        if let constraint = imageView.constraints.filter({ $0.firstAttribute == .width }).first {
            constraint.constant = imageSize.width
        }
        if let constraint = imageView.constraints.filter({ $0.firstAttribute == .height }).first {
            constraint.constant = imageSize.height
        }
    }
}
