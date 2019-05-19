//
//  BracketVC.swift
//  KRTournamentViewDemo
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import UIKit
import KRTournamentView

protocol BracketVCDelegate: class {
    func bracketVCDidClose(_ bracketVC: BracketVC)
}

final class BracketVC: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tournamentView: KRTournamentView!
    @IBOutlet private weak var entriesLabel: UILabel!
    @IBOutlet private weak var winnersLabel: UILabel!

    private var numberOfEntries: Int = 2 {
        didSet {
            entriesLabel?.text = "\(numberOfEntries)"
            tournamentView?.reloadData()
        }
    }

    private var numberOfWinners: Int = 1 {
        didSet {
            winnersLabel?.text = "\(numberOfWinners)"
            tournamentView?.reloadData()
        }
    }

    var matchPath: MatchPath!
    var builder: TournamentBuilder!

    weak var delegate: BracketVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        numberOfEntries = builder.children.count
        numberOfWinners = builder.numberOfWinners
        tournamentView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.alpha = 1
        }
    }
}

// MARK: - Actions ------------

extension BracketVC {
    @IBAction func entriesButtonTapped(_ button: UIButton) {
        let actionSheet = UIAlertController(title: "Number of entries", message: nil, preferredStyle: .actionSheet)
        (1..<6).forEach { index in
            actionSheet.addAction(UIAlertAction(title: "\(index)", style: .default) { [unowned self] _ in
                self.numberOfEntries = index
                if self.numberOfWinners > index - 1 {
                    self.numberOfWinners = max(1, min(index, index - 1))
                }
            })
        }
        present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func winnersButtonTapped(_ button: UIButton) {
        let actionSheet = UIAlertController(title: "Number of winenrs", message: nil, preferredStyle: .actionSheet)
        (1..<5).forEach { index in
            actionSheet.addAction(UIAlertAction(title: "\(index)", style: .default) { [unowned self] _ in
                self.numberOfWinners = max(1, min(index, self.numberOfEntries - 1))
            })
        }
        present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func closeButtonTapped(_ button: UIButton) {
        builder.numberOfWinners = numberOfWinners
        builder.children = (0..<numberOfEntries).map { _ in
            (matchPath.layer == 1) ? .entry : .bracket(.init(numberOfLayers: matchPath.layer - 1))
        }
        delegate?.bracketVCDidClose(self)

        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.alpha = 0
        }, completion: { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        })
    }
}

// MARK: - KRTournament data source -------------------

extension BracketVC: KRTournamentViewDataSource {
    func structure(of tournamentView: KRTournamentView) -> Bracket {
        return TournamentBuilder.build(numberOfLayers: 1, numberOfEntries: numberOfEntries, numberOfWinners: numberOfWinners, handler: nil)
    }

    func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry {
        return KRTournamentViewEntry()
    }

    func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch {
        return KRTournamentViewMatch()
    }
}

// MARK: - KRTournament delegate -------------------

extension BracketVC: KRTournamentViewDelegate {
    func entrySize(in tournamentView: KRTournamentView) -> CGSize {
        return .init(width: 0, height: 50)
    }
}
