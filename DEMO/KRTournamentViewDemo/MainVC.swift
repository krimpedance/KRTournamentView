//
//  MainVC.swift
//  KRTournamentViewDemo
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit
import KRTournamentView

final class MainVC: UIViewController {

    @IBOutlet private weak var stageView: StageView!
    @IBOutlet private weak var tournamentView: KRTournamentView!
    @IBOutlet private weak var styleLabel: UILabel!
    @IBOutlet private weak var layerLabel: UILabel!

    private var style: KRTournamentViewStyle = .left {
        didSet {
            styleLabel.text = style.str
            tournamentView.style = style
            tournamentView.reloadData()
        }
    }

    private var numberOfLayers: Int = 3 {
        didSet {
            layerLabel.text = "\(numberOfLayers)"
            builder = .init(numberOfLayers: numberOfLayers)
        }
    }

    private var builder: TournamentBuilder = .init(numberOfLayers: 3) {
        didSet { tournamentView.reloadData() }
    }

    private var entryNames = [Int: String]() {
        didSet { tournamentView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tournamentView.dataSource = self
        tournamentView.delegate = self
        tournamentView.style = style
        tournamentView.lineWidth = 2
    }
}

// MARK: - Button actions -------------------

extension MainVC {
    @IBAction func styleBtnTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Style", message: nil, preferredStyle: .actionSheet)
        KRTournamentViewStyle.allItems.forEach { style in
            actionSheet.addAction(UIAlertAction(title: style.str, style: .default) { [unowned self] _ in
                self.style = style
            })
        }
        present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func layerBtnTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Number of Layers", message: nil, preferredStyle: .actionSheet)
        (1..<5).forEach { index in
            actionSheet.addAction(UIAlertAction(title: "\(index)", style: .default) { [unowned self] _ in
                self.numberOfLayers = index
            })
        }
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - KRTournament data source -------------------

extension MainVC: KRTournamentViewDataSource {
    func structure(of tournamentView: KRTournamentView) -> Bracket {
        return builder.build(format: true)
    }

    func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry {
        let entry = KRTournamentViewEntry()
        switch tournamentView.style {
        case .left, .right, .leftRight:
            entry.textLabel.text = entryNames[index] ?? "entry \(index+1)"
        case .top, .bottom, .topBottom:
            entry.textLabel.verticalText = entryNames[index] ?? "entry \(index+1)"
        }
        return entry
    }

    func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch {
        return MyMatch()
    }
}

// MARK: - KRTournament delegate -------------------

extension MainVC: KRTournamentViewDelegate {
    func tournamentView(_ tournamentView: KRTournamentView, didSelectEntryAt index: Int) {
        print("entry \(index) is selected")

        let alert = UIAlertController(title: "Change name", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            if let text = alert.textFields?.first?.text, text != "" {
                self.entryNames[index] = text
            } else {
                self.entryNames.removeValue(forKey: index)
            }
        })
        present(alert, animated: true, completion: nil)
    }

    func tournamentView(_ tournamentView: KRTournamentView, didSelectMatchAt matchPath: MatchPath) {
        print("match \(matchPath.layer)-\(matchPath.item) is selected")
        guard let builder = builder.getChildBuilder(for: matchPath) else { return }
        guard let bracketVC = storyboard?.instantiateViewController(withIdentifier: "BracketVC") as? BracketVC else { return }
        bracketVC.matchPath = matchPath
        bracketVC.builder = builder
        bracketVC.delegate = self
        present(bracketVC, animated: false, completion: nil)
    }
}

// MARK: - BracketVC delegate -------------------

extension MainVC: BracketVCDelegate {
    func bracketVCDidClose(_ bracketVC: BracketVC) {
        tournamentView.reloadData()
    }
}
