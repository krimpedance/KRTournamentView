//
//  KRTournamentViewEntry.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

/// KRTournamentViewEntry is a view for entry of KRTournamentView
open class KRTournamentViewEntry: UIView {
    /// Index in tournament view.
    internal(set) public var index: Int!

    /// Default is nil. Label will be created if necessary.
    private(set) open lazy var textLabel: KRTournamentViewEntryLabel = self.makeTextLabel()

    /// Initializer
    public convenience init() {
        self.init(frame: CGRect(origin: .zero, size: Default.entrySize(with: Default.style)))
        backgroundColor = .clear
        clipsToBounds = true
    }
}

// MARK: - Private actions ------------

private extension KRTournamentViewEntry {
    func makeTextLabel() -> KRTournamentViewEntryLabel {
        let label = KRTournamentViewEntryLabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        addConstraints([
            NSLayoutConstraint(item: label, attribute: .top, toItem: self),
            NSLayoutConstraint(item: label, attribute: .bottom, toItem: self),
            NSLayoutConstraint(item: label, attribute: .left, toItem: self),
            NSLayoutConstraint(item: label, attribute: .right, toItem: self)
        ])

        return label
    }
}
