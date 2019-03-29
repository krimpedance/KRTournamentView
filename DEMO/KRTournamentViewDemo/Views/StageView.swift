//
//  StageView.swift
//  KRTournamentViewDemo
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit
import KRTournamentView

class StageView: UIView {

    @IBOutlet weak var tournamentView: KRTournamentView!

    var observations = [NSKeyValueObservation]()

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .white
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.5

        tournamentView.dataSource = self
        tournamentView.delegate = self
        tournamentView.lineWidth = 2

        setUpObservers()
    }
}

// MARK: - Actions -------------------

extension StageView {
    func setUpObservers() {
        observations = [
            DataStore.instance.observe(\.entries, options: .new) { _, _ in
                self.tournamentView.reloadData()
            },
            DataStore.instance.observe(\.styleNumber, options: .new) { _, _ in
                self.tournamentView.style = DataStore.instance.style
                self.tournamentView.reloadData()
            },
            DataStore.instance.observe(\.lineColor, options: .new) { _, _ in
                self.tournamentView.lineColor = DataStore.instance.lineColor
                self.tournamentView.reloadData()
            },
            DataStore.instance.observe(\.preferredLineColor, options: .new) { _, _ in
                self.tournamentView.preferredLineColor = DataStore.instance.preferredLineColor
                self.tournamentView.reloadData()
            },
            DataStore.instance.observe(\.fixOrientation, options: .new) { _, _ in
                self.tournamentView.fixOrientation = DataStore.instance.fixOrientation
            }
        ]
    }
}

// MARK: - KRTournament data source -------------------

extension StageView: KRTournamentViewDataSource {
    func numberOfLayers(in tournamentView: KRTournamentView) -> Int {
        return DataStore.instance.numberOfLayers
    }

    func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry? {
        guard DataStore.instance.entries.contains(index) else { return nil }

        let entry = KRTournamentViewEntry()
        switch tournamentView.style {
        case .left, .right, .leftRight:
            entry.textLabel.text = "entry \(index+1)"
        case .top, .bottom, .topBottom:
            entry.textLabel.verticalText = "entry \(index+1)"
        }
        return entry
    }

    func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch {
        let match = KRTournamentViewMatch()
        match.preferredSide = (Int.random(in: 0...1) == 0) ? .home : .away
        return match
    }
}

// MARK: - KRTournament delegate -------------------

extension StageView: KRTournamentViewDelegate {
    func tournamentView(_ tournamentView: KRTournamentView, didSelectEntryAt index: Int) {
        print("entry \(index) is selected")
    }

    func tournamentView(_ tournamentView: KRTournamentView, didSelectMatchAt matchPath: MatchPath) {
        print("match \(matchPath.layer)-\(matchPath.number) is selected")
    }
}
