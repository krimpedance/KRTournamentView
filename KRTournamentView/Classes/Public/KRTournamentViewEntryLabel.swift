//
//  KRTournamentViewEntryLabel.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

/// KRTournamentViewEntryLabel is a label which expanded UILabel for vertical Text.
public class KRTournamentViewEntryLabel: UILabel {
    /// Sets text to be written vertically. This is just insert new line each character.
    public var verticalText: String? {
        willSet {
            guard let text = newValue else { return }
            self.text = text.map { $0 }.reduce("", { (result, char) -> String in return "\(result)\(char)\n" })
        }
    }
}
