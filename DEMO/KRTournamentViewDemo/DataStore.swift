//
//  DataStore.swift
//  KRTournamentViewDemo
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit
import KRTournamentView

extension KRTournamentViewStyle {
    var rawValue: Int {
        switch self {
        case .left: return 0
        case .right: return 1
        case .top: return 2
        case .bottom: return 3
        case .leftRight: return 4
        case .topBottom: return 5
        }
    }

    var str: String {
        switch self {
        case .left: return "Left"
        case .right: return "Right"
        case .top: return "Top"
        case .bottom: return "Bottom"
        case .leftRight: return "LeftRight"
        case .topBottom: return "TopBottom"
        }
    }

    init(rawValue: Int) {
        switch rawValue {
        case 0: self = .left
        case 1: self = .right
        case 2: self = .top
        case 3: self = .bottom
        case 4: self = .leftRight(direction: .top)
        case 5: self = .topBottom(direction: .right)
        default: self = .left
        }
    }
}

class DataStore: NSObject {
    static let instance = DataStore()

    @objc dynamic var numberOfLayers: Int = 3 {
        didSet {
            let num = Int(pow(2, Double(numberOfLayers)))
            entries = (0..<num).map { $0 }
        }
    }
    @objc dynamic var entries: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    @objc dynamic var styleNumber: Int = 0
    @objc dynamic var lineColor: UIColor = .black
    @objc dynamic var preferredLineColor: UIColor = .red
    @objc dynamic var fixOrientation: Bool = false

    var style: KRTournamentViewStyle {
        get { return KRTournamentViewStyle(rawValue: styleNumber) }
        set { styleNumber = newValue.rawValue }
    }

    var colorList: [UIColor] {
        return [
            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            #colorLiteral(red: 1, green: 0.5411764706, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 1, green: 0.3215686275, blue: 0.3215686275, alpha: 1), #colorLiteral(red: 1, green: 0.09019607843, blue: 0.2666666667, alpha: 1), #colorLiteral(red: 0.8352941176, green: 0, blue: 0, alpha: 1),
            #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 0.8784313725, green: 0.2509803922, blue: 0.9843137255, alpha: 1), #colorLiteral(red: 0.8352941176, green: 0, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.6666666667, green: 0, blue: 1, alpha: 1),
            #colorLiteral(red: 0.5098039216, green: 0.6941176471, blue: 1, alpha: 1), #colorLiteral(red: 0.2666666667, green: 0.5411764706, blue: 1, alpha: 1), #colorLiteral(red: 0.1607843137, green: 0.4745098039, blue: 1, alpha: 1), #colorLiteral(red: 0.1607843137, green: 0.3843137255, blue: 1, alpha: 1),
            #colorLiteral(red: 0.7254901961, green: 0.9647058824, blue: 0.7921568627, alpha: 1), #colorLiteral(red: 0.4117647059, green: 0.9411764706, blue: 0.6823529412, alpha: 1), #colorLiteral(red: 0, green: 0.9019607843, blue: 0.462745098, alpha: 1), #colorLiteral(red: 0, green: 0.7843137255, blue: 0.3254901961, alpha: 1),
            #colorLiteral(red: 1, green: 0.8196078431, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 1, green: 0.6705882353, blue: 0.2509803922, alpha: 1), #colorLiteral(red: 1, green: 0.568627451, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.4274509804, blue: 0, alpha: 1)
        ]
    }

    private override init() { super.init() }
}
