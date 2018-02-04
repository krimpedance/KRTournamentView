//
//  ColorListVC.swift
//  KRTournamentViewDemo
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

enum ColorType {
    case base, preferred
}

class ColorListVC: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewBottomConstraint: NSLayoutConstraint!

    var type = ColorType.base

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

extension ColorListVC {
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
}

// MARK: - UITableView datasource -------------------

extension ColorListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.instance.colorList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.backgroundColor = DataStore.instance.colorList[indexPath.row]
        return cell
    }
}

// MARK: - UITableView delegate -------------------

extension ColorListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let color = DataStore.instance.colorList[indexPath.row]
        switch type {
        case .base:
            DataStore.instance.lineColor = color
        case .preferred:
            DataStore.instance.preferredLineColor = color
        }

        hide()
    }
}
