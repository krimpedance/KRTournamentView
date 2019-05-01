//
//  KRTournamentView.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

/// KRTournamentView is a flexible tournament bracket which can support to the various structure.
@IBDesignable public class KRTournamentView: UIView, KRTournamentViewDataStore {

    // MARK: Private properties -------------------

    private lazy var drawingView = KRTournamentDrawingView(dataStore: self)
    private lazy var firstEntriesView = KRTournamentEntriesView(dataStore: self, drawHalf: .first)
    private lazy var secondEntriesView = KRTournamentEntriesView(dataStore: self, drawHalf: .second)
    private var orientation = UIDeviceOrientation.portrait
    private var orientationObserver: NSObjectProtocol?

    // MARK: Public properties -------------------

    /// KRTournamentView style. Default is `.left`.
    public var style: KRTournamentViewStyle = Default.style

    /// Structure of tournament. This is set by the data source.
    internal(set) public var tournamentStructure: Bracket = Default.tournamentStructure

    /// entry size. This is set by the delegate. Default is CGSize(80.0, 30.0).
    internal(set) public var entrySize: CGSize = Default.entrySize(with: Default.style)

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

        orientationObserver = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.checkRotation()
        }
    }
}

// MARK: - Private layout actions -------------------

private extension KRTournamentView {
    func updateLayout() {
        entrySize = delegate?.entrySize(in: self) ?? Default.entrySize(with: style)
        removeConstraints()

        addSubview(drawingView)
        addSubview(firstEntriesView)
        addSubview(secondEntriesView)

        let sizeAttribute: NSLayoutConstraint.Attribute = style.isVertical ? .width : .height
        let firstAttribute: NSLayoutConstraint.Attribute = style.isVertical ? .left : .top
        let secondAttribute: NSLayoutConstraint.Attribute = style.isVertical ? .right : .bottom
        let commonAttributes: [NSLayoutConstraint.Attribute] = style.isVertical ? [.top, .bottom] : [.left, .right]

        addConstraints(
            NSLayoutConstraint.constraints(from: firstEntriesView, to: self, attributes: commonAttributes + [firstAttribute]) +
                NSLayoutConstraint.constraints(from: secondEntriesView, to: self, attributes: commonAttributes + [secondAttribute]) +
                NSLayoutConstraint.constraints(from: drawingView, to: self, attributes: commonAttributes) +
                [
                    NSLayoutConstraint(item: drawingView, attribute: firstAttribute, toItem: firstEntriesView, attribute: secondAttribute, constant: 5),
                    NSLayoutConstraint(item: secondEntriesView, attribute: firstAttribute, toItem: drawingView, attribute: secondAttribute, constant: 5)
            ]
        )

        let entriesSpaceWidth = style.isVertical ? entrySize.width : entrySize.height
        var (firstConstant, secondConstant) = (entriesSpaceWidth, entriesSpaceWidth)
        switch style {
        case .left, .top: secondConstant = 0
        case .right, .bottom: firstConstant = 0
        case .leftRight, .topBottom: break
        }
        firstEntriesView.addConstraint(NSLayoutConstraint(item: firstEntriesView, attribute: sizeAttribute, constant: firstConstant))
        secondEntriesView.addConstraint(NSLayoutConstraint(item: secondEntriesView, attribute: sizeAttribute, constant: secondConstant))
    }

    func removeConstraints() {
        drawingView.removeFromSuperview()
        firstEntriesView.removeFromSuperview()
        secondEntriesView.removeFromSuperview()

        drawingView.removeConstraints(drawingView.constraints)
        firstEntriesView.removeConstraints(firstEntriesView.constraints)
        secondEntriesView.removeConstraints(secondEntriesView.constraints)
    }

    func checkRotation() {
        let orientation = UIDevice.current.orientation
        if !fixOrientation || self.orientation == orientation { return }

        switch (self.orientation, orientation) {
        case (.portrait, .landscapeLeft), (.landscapeLeft, .portraitUpsideDown),
             (.landscapeRight, .portrait), (.portraitUpsideDown, .landscapeRight):
            style.rotateLeft()

        case (.portrait, .landscapeRight), (.landscapeLeft, .portrait),
             (.landscapeRight, .portraitUpsideDown), (.portraitUpsideDown, .landscapeLeft):
            style.rotateRight()

        case (.portrait, .portraitUpsideDown), (.landscapeLeft, .landscapeRight),
             (.landscapeRight, .landscapeLeft), (.portraitUpsideDown, .portrait):
            style.reverse()

        default: break
        }

        guard [.portrait, .landscapeLeft, .landscapeRight, .portraitUpsideDown].contains(orientation) else { return }

        self.orientation = orientation
        setNeedsLayout()
    }
}

// MARK: - Private actions -------------------

private extension KRTournamentView {
    func reloadEntries() {
        func getView(entry: Entry) -> KRTournamentViewEntry {
            let view = (dataSource ?? self).tournamentView(self, entryAt: entry.index)
            view.index = entry.index
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectEntry(sender:))))
            return view
        }

        firstEntriesView.entries = tournamentStructure.entries(style: style, drawHalf: .first).map(getView)
        secondEntriesView.entries = tournamentStructure.entries(style: style, drawHalf: .second).map(getView)
    }

    func reloadMatches() {
        drawingView.matches = tournamentStructure.matchPaths.map { matchPath in
            let match = (dataSource ?? self).tournamentView(self, matchAt: matchPath)
            match.matchPath = matchPath
            match.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectMatch(sender:))))
            return match
        }
    }

    @objc func didSelectEntry(sender: UITapGestureRecognizer) {
        guard let entry = sender.view as? KRTournamentViewEntry else { return }
        delegate?.tournamentView(self, didSelectEntryAt: entry.index)
    }

    @objc func didSelectMatch(sender: UITapGestureRecognizer) {
        guard let match = sender.view as? KRTournamentViewMatch else { return }
        delegate?.tournamentView(self, didSelectMatchAt: match.matchPath)
    }
}

// MARK: - Internal actions -------------------

extension KRTournamentView {
}

// MARK: - Public actions -------------------

public extension KRTournamentView {
    /// Reloads everything from scratch. Redisplays entries and matches.
    func reloadData() {
        tournamentStructure = (dataSource ?? self).structure(of: self)
        reloadEntries()
        reloadMatches()
        setNeedsLayout()
        drawingView.setNeedsDisplay()
    }
}

// MARK: - KRTournamentView data source -------------------

extension KRTournamentView: KRTournamentViewDataSource {
    public func structure(of tournamentView: KRTournamentView) -> Bracket {
        return Default.tournamentStructure
    }

    public func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry {
        return Default.tournamentViewEntry
    }

    public func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch {
        return Default.tournamentViewMatch
    }
}
