//
//  KRTournamentView.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

/// KRTournamentView is a flexible tournament bracket which can support to the various structure.
@IBDesignable public class KRTournamentView: UIView, KRTournamentViewDataStore {

    // MARK: Protocol properties -------------------

    /// KRTournamentView style. Default is `.left`.
    public var style: KRTournamentViewStyle = Default.style

    /// Number of layers. This is set by the data source. Default is 2.
    internal(set) public var numberOfLayers: Int = Default.numberOfLayers {
        willSet {
            assert(newValue > 0, "numberOfLayers must be greater than 0.")
        }
    }

    /// entry size. This is set by the delegate. Default is CGSize(80.0, 30.0).
    internal(set) public var entrySize: CGSize = Default.entrySize(with: Default.style)

    var excludes = [Int]()

    // MARK: Properties -------------------

    let drawingView = KRTournamentDrawingView()
    let firstEntriesView = KRTournamentEntriesView(half: .first)
    let secondEntriesView = KRTournamentEntriesView(half: .second)
    var orientation = UIDeviceOrientation.portrait
    var orientationObserver: NSObjectProtocol?

    /// KRTournamentView data source.
    public weak var dataSource: KRTournamentViewDataSource?

    /// KRTournamentView delegate.
    public weak var delegate: KRTournamentViewDelegate?

    /// Line color
    @IBInspectable public var lineColor: UIColor {
        get { return drawingView.lineColor }
        set { drawingView.lineColor = newValue }
    }

    /// Preferred line (i.e. winner line) color.
    @IBInspectable public var preferredLineColor: UIColor {
        get { return drawingView.preferredLineColor }
        set { drawingView.preferredLineColor = newValue }
    }

    /// Line width.
    @IBInspectable public var lineWidth: CGFloat {
        get { return drawingView.lineWidth }
        set { drawingView.lineWidth = newValue }
    }

    /// Preferred line (i.e. winner line) width. If nil, `lineWidth` is used.
    public var preferredLineWidth: CGFloat? {
        get { return drawingView.preferredLineWidth }
        set { drawingView.preferredLineWidth = newValue }
    }

    /// If true, the tournament direction isn't changed when the device is rotated.
    @IBInspectable public var fixOrientation: Bool = Default.fixOrientation

    // MARK: Lifecycle ---------------

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
        reloadData()

        if orientationObserver != nil { return }

        orientationObserver = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main, using: {[weak self] _ in
            self?.checkRotation()
        })
    }

    deinit {
        NotificationCenter.default.removeObserver(orientationObserver!)
    }
}

// MARK: - Public actions -------------------

public extension KRTournamentView {
    /// Reloads everything from scratch. Redisplays entries and matches.
    func reloadData() {
        numberOfLayers = (dataSource ?? self).numberOfLayers(in: self)
        reloadEntries()
        reloadMatches()
        setNeedsLayout()
        drawingView.setNeedsDisplay()
    }
}
