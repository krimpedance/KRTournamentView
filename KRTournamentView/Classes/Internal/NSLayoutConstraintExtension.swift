//
//  NSLayoutConstraintExtension.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    convenience init(item view1: Any, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation = .equal, toItem view2: Any? = nil, attribute attr2: NSLayoutConstraint.Attribute? = nil, constant: CGFloat = 0) {
        self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2 ?? attr1, multiplier: 1.0, constant: constant)
    }

    static func constraints(from view1: Any, to view2: Any, attributes: [NSLayoutConstraint.Attribute]) -> [NSLayoutConstraint] {
        return attributes.map { attr in
            NSLayoutConstraint(item: view1, attribute: attr, toItem: view2)
        }
    }
}
