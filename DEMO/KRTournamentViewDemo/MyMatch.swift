//
//  MyMatch.swift
//  KRTournamentViewDemo
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import Foundation
import KRTournamentView

final class MyMatch: KRTournamentViewMatch {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init() {
        super.init(frame: .zero)

        backgroundColor = UIColor.green.withAlphaComponent(0.1)
        layer.borderColor = UIColor.green.withAlphaComponent(0.2).cgColor
        layer.borderWidth = 1

        let imageView = UIImageView(image: #imageLiteral(resourceName: "edit"))
        imageView.alpha = 0.8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
