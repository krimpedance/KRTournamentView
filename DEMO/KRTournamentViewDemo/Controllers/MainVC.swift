//
//  MainVC.swift
//  KRTournamentViewDemo
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//
//  swiftlint:disable force_cast

import UIKit
import KRTournamentView

class MainVC: UIViewController {

    @IBOutlet weak var stageView: StageView!

    @IBOutlet weak var entriesLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var lineColorView: UIView!
    @IBOutlet weak var preferredLineColorView: UIView!
    @IBOutlet weak var fixOrientationLabel: UILabel!

    var observations = [NSKeyValueObservation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpObservers()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight]
    }
}

// MARK: - Actions -------------------

extension MainVC {
    func setUpObservers() {
        observations = [
            DataStore.instance.observe(\.entries, options: .new) { _, _ in
                self.entriesLabel.text = "\(DataStore.instance.entries.count)"
            },
            DataStore.instance.observe(\.styleNumber, options: .new) { _, _ in
                self.styleLabel.text = DataStore.instance.style.str
            },
            DataStore.instance.observe(\.lineColor, options: .new) { _, _ in
                self.lineColorView.backgroundColor = DataStore.instance.lineColor
            },
            DataStore.instance.observe(\.preferredLineColor, options: .new) { _, _ in
                self.preferredLineColorView.backgroundColor = DataStore.instance.preferredLineColor
            }
        ]
    }

    func showStyleActionSheet() {
        let actionSheet = UIAlertController(title: "Select style", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Left", style: .default) { _ in DataStore.instance.style = .left })
        actionSheet.addAction(UIAlertAction(title: "Right", style: .default) { _ in DataStore.instance.style = .right })
        actionSheet.addAction(UIAlertAction(title: "Top", style: .default) { _ in DataStore.instance.style = .top })
        actionSheet.addAction(UIAlertAction(title: "Bottom", style: .default) { _ in DataStore.instance.style = .bottom })
        actionSheet.addAction(UIAlertAction(title: "LeftRight", style: .default) { _ in DataStore.instance.style = .leftRight(direction: .top) })
        actionSheet.addAction(UIAlertAction(title: "TopBottom", style: .default) { _ in DataStore.instance.style = .topBottom(direction: .right) })
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - Button actions -------------------

extension MainVC {
    @IBAction func entriesCountBtnTapped(_ sender: Any) {
        let selectEntriesVC = storyboard!.instantiateViewController(withIdentifier: "SelectEntriesVC")
        present(selectEntriesVC, animated: false, completion: nil)
    }

    @IBAction func styleBtnTapped(_ sender: Any) {
        showStyleActionSheet()
    }

    @IBAction func lineColorBtnTapped(_ sender: Any) {
        let colorListVC = storyboard!.instantiateViewController(withIdentifier: "ColorListVC") as! ColorListVC
        colorListVC.type = .base
        present(colorListVC, animated: false, completion: nil)
    }

    @IBAction func preferredLineColorBtnTapped(_ sender: Any) {
        let colorListVC = storyboard!.instantiateViewController(withIdentifier: "ColorListVC") as! ColorListVC
        colorListVC.type = .preferred
        present(colorListVC, animated: false, completion: nil)
    }

    @IBAction func fixOrientationBtnTapped(_ sender: Any) {
        DataStore.instance.fixOrientation = !DataStore.instance.fixOrientation
        fixOrientationLabel.text = DataStore.instance.fixOrientation ? "ON" : "OFF"
    }
}
