//
//  SelectEntriesVC.swift
//  KRTournamentViewDemo
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit
import KRTournamentView

class SelectEntriesVC: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var layersNumberLabel: UILabel!
    @IBOutlet weak var tournamentView: KRTournamentView!
    @IBOutlet weak var previewButton: UIButton!

    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewBottomConstraint: NSLayoutConstraint!

    var observations = [NSKeyValueObservation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
        cardViewTopConstraint.constant = view.frame.height
        cardViewBottomConstraint.constant = -view.frame.height
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        show()
    }
}

// MARK: - Actions -------------------

extension SelectEntriesVC {
    func setUp() {
        layersNumberLabel.text = "\(DataStore.instance.numberOfLayers)"

        tournamentView.style = DataStore.instance.style
        tournamentView.dataSource = self
        tournamentView.delegate = self
        tournamentView.lineColor = .lightGray
        tournamentView.layer.borderWidth = 1
        tournamentView.layer.borderColor = UIColor.black.cgColor
        tournamentView.backgroundColor = .white

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(previewButtonLongPressed(_:)))
        longPress.minimumPressDuration = 0
        previewButton.addGestureRecognizer(longPress)

        setUpObservers()
    }

    func setUpObservers() {
        observations = [
            DataStore.instance.observe(\.entries, options: .new) { _, _ in
                self.layersNumberLabel.text = "\(DataStore.instance.numberOfLayers)"
                self.tournamentView.reloadData()
            },
            DataStore.instance.observe(\.styleNumber, options: .new) { _, _ in
                self.tournamentView.style = DataStore.instance.style
                self.tournamentView.reloadData()
            }
        ]
    }

    func show() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.cardViewTopConstraint.constant = 20
                self.cardViewBottomConstraint.constant = 20
                self.view.layoutIfNeeded()
            })
        })
    }

    func hide() {
        observations.forEach { $0.invalidate() }
        observations = []

        UIView.animate(withDuration: 0.3, animations: {
            self.cardViewTopConstraint.constant = self.view.frame.height
            self.cardViewBottomConstraint.constant = -self.view.frame.height
            self.view.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 0
                self.dismiss(animated: false, completion: nil)
            })
        })
    }

    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Select number of layers", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "1", style: .default) { _ in DataStore.instance.numberOfLayers = 1 })
        actionSheet.addAction(UIAlertAction(title: "2", style: .default) { _ in DataStore.instance.numberOfLayers = 2 })
        actionSheet.addAction(UIAlertAction(title: "3", style: .default) { _ in DataStore.instance.numberOfLayers = 3 })
        actionSheet.addAction(UIAlertAction(title: "4", style: .default) { _ in DataStore.instance.numberOfLayers = 4 })
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - Button actions -------------------

extension SelectEntriesVC {
    @IBAction func layersNumberButtonTapped(_ sender: Any) {
        showActionSheet()
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        hide()
    }

    @objc func previewButtonLongPressed(_ longPressGR: UILongPressGestureRecognizer) {
        switch longPressGR.state {
        case .began:
            view.alpha = 0
        case .ended:
            view.alpha = 1
        default: break
        }
    }
}

// MARK: - KRTournament data source -------------------

extension SelectEntriesVC: KRTournamentViewDataSource {
    func numberOfLayers(in tournamentView: KRTournamentView) -> Int {
        return DataStore.instance.numberOfLayers
    }

    func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry? {
        let entry = KRTournamentViewEntry()
        if DataStore.instance.entries.contains(index) {
            entry.textLabel.text = "\(index+1): Show"
            entry.textLabel.textColor = .black
        } else {
            entry.textLabel.text = "\(index+1): Hide"
            entry.textLabel.textColor = .lightGray
        }
        return entry
    }

    func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch {
        return KRTournamentViewMatch()
    }
}

// MARK: - KRTournament delegate -------------------

extension SelectEntriesVC: KRTournamentViewDelegate {
    func entrySize(in tournamentView: KRTournamentView) -> CGSize {
        return CGSize(width: 100, height: 30)
    }

    func tournamentView(_ tournamentView: KRTournamentView, didSelectEntryAt index: Int) {
        if DataStore.instance.entries.contains(index) {
            DataStore.instance.entries = DataStore.instance.entries.filter { $0 != index }
        } else {
            DataStore.instance.entries.append(index)
        }
        tournamentView.reloadData()
    }
}
