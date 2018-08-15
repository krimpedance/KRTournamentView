//
//  KRTournamentDrawingView.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

class KRTournamentDrawingView: UIView, KRTournamentCalculatable {
    fileprivate typealias DrawInfo = (cross: CGPoint, home: CGPoint, away: CGPoint, isFinished: Bool)

    weak var dataStore: KRTournamentViewDataStore!

    lazy var drawingPath: UIBezierPath = {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.lineCapStyle = .square
        return path
    }()

    lazy var preferredDrawingPath: UIBezierPath = {
        let path = UIBezierPath()
        path.lineWidth = preferredLineWidth ?? lineWidth
        path.lineCapStyle = .square
        return path
    }()

    var half: DrawHalf = .first
    var lineColor: UIColor = Default.lineColor
    var preferredLineColor: UIColor = Default.preferredLineColor
    var lineWidth: CGFloat = Default.lineWidth
    var preferredLineWidth: CGFloat?

    var matches = [KRTournamentViewMatch]() {
        willSet { matches.forEach { $0.removeFromSuperview() } }
    }

    var drawMargin: CGFloat {
        return dataStore.style.isVertical ? validEntrySize.height / 2 : validEntrySize.width / 2
    }

    convenience init() {
        self.init(frame: .zero)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawingPath.removeAllPoints()
        preferredDrawingPath.removeAllPoints()
        drawTournament()
    }
}

// MARK: - Get action -------------------

private extension KRTournamentDrawingView {
    func getBezierPath(usingPreferredColor using: Bool) -> UIBezierPath {
        return using ? preferredDrawingPath : drawingPath
    }

    func getBottomLayerDrawInfo(with drawOffset: CGFloat) -> DrawInfo {
        let teamNum = (0..<maxEntryNumber).filter { !dataStore.excludes.contains($0) }.count
        let homeTeamNum = (0..<maxEntryNumber/2).filter { !dataStore.excludes.contains($0) }.count
        let awayTeamNum = teamNum - homeTeamNum
        let subOffset = (half == .first) ? 0 : CGFloat(homeTeamNum)

        let point: CGPoint
        switch dataStore.style {
        case .left,
             .leftRight where half == .first:
            let num = dataStore.style.isHalf ? teamNum : homeTeamNum
            let yPoint = (num == 1) ? bounds.height / 2 : drawMargin + (stepSize.height * drawOffset)
            point = CGPoint(x: 0, y: yPoint)

        case .right, .leftRight:
            let num = dataStore.style.isHalf ? teamNum : awayTeamNum
            let yPoint = (num == 1) ? bounds.height / 2 : drawMargin + (stepSize.height * (drawOffset - subOffset))
            point = CGPoint(x: bounds.width, y: yPoint)

        case .top,
             .topBottom where half == .first:
            let num = dataStore.style.isHalf ? teamNum : homeTeamNum
            let xPoint = (num == 1) ? bounds.width / 2 : drawMargin + (stepSize.width * drawOffset)
            point = CGPoint(x: xPoint, y: 0)

        case .bottom, .topBottom:
            let num = dataStore.style.isHalf ? teamNum : awayTeamNum
            let xPoint = (num == 1) ? bounds.width / 2 : drawMargin + (stepSize.width * (drawOffset - subOffset))
            point = CGPoint(x: xPoint, y: bounds.height)
        }

        return DrawInfo(cross: point, home: point, away: point, isFinished: false)
    }

    func getCrossPoint(layer: Int, homeDrawInfo: DrawInfo, awayDrawInfo: DrawInfo) -> CGPoint {
        switch dataStore.style {
        case .leftRight where layer == dataStore.numberOfLayers:
            return CGPoint(x: homeDrawInfo.cross.x + stepSize.width, y: homeDrawInfo.cross.y + ((awayDrawInfo.cross.y - homeDrawInfo.cross.y) / 2))
        case .topBottom where layer == dataStore.numberOfLayers:
            return CGPoint(x: homeDrawInfo.cross.x + ((awayDrawInfo.cross.x - homeDrawInfo.cross.x) / 2), y: homeDrawInfo.cross.y + stepSize.height)
        case .left,
             .leftRight where half == .first:
            return CGPoint(x: homeDrawInfo.cross.x + stepSize.width, y: homeDrawInfo.cross.y + ((awayDrawInfo.cross.y - homeDrawInfo.cross.y) / 2))
        case .right, .leftRight:
            return CGPoint(x: homeDrawInfo.cross.x - stepSize.width, y: homeDrawInfo.cross.y + ((awayDrawInfo.cross.y - homeDrawInfo.cross.y) / 2))
        case .top,
             .topBottom where half == .first:
            return CGPoint(x: homeDrawInfo.cross.x + ((awayDrawInfo.cross.x - homeDrawInfo.cross.x) / 2), y: homeDrawInfo.cross.y + stepSize.height)
        case .bottom, .topBottom:
            return CGPoint(x: homeDrawInfo.cross.x + ((awayDrawInfo.cross.x - homeDrawInfo.cross.x) / 2), y: homeDrawInfo.cross.y - stepSize.height)
        }
    }

    func getMatch(layer: Int, number: Int) -> KRTournamentViewMatch? {
        return matches.filter { $0.matchPath == MatchPath(layer: layer, number: number) }.first
    }
}

// MARK: - Drawing action -------------------

private extension KRTournamentDrawingView {
    func drawTournament() {
        defer { half = .first }

        guard let drawInfo = drawRecursively(layer: dataStore.numberOfLayers, number: 0) else { return }

        // Draw the top line
        let bezierPath = getBezierPath(usingPreferredColor: drawInfo.isFinished)
        bezierPath.move(to: CGPoint(x: drawInfo.cross.x, y: drawInfo.cross.y))
        switch dataStore.style {
        case .left:
            bezierPath.addLine(to: CGPoint(x: drawInfo.cross.x + stepSize.width, y: drawInfo.cross.y))
        case .right:
            bezierPath.addLine(to: CGPoint(x: drawInfo.cross.x - stepSize.width, y: drawInfo.cross.y))
        case .top:
            bezierPath.addLine(to: CGPoint(x: drawInfo.cross.x, y: drawInfo.cross.y + stepSize.height))
        case .bottom:
            bezierPath.addLine(to: CGPoint(x: drawInfo.cross.x, y: drawInfo.cross.y - stepSize.height))
        case .leftRight(let direction):
            let length: CGFloat = (direction == .bottom) ? 20 : -20
            bezierPath.addLine(to: CGPoint(x: drawInfo.cross.x, y: drawInfo.cross.y + length))
        case .topBottom(let direction):
            let length: CGFloat = (direction == .left) ? -20 : 20
            bezierPath.addLine(to: CGPoint(x: drawInfo.cross.x + length, y: drawInfo.cross.y))
        }

        lineColor.setStroke()
        drawingPath.stroke()
        preferredLineColor.setStroke()
        preferredDrawingPath.stroke()
    }

    func drawRecursively(layer: Int, number: Int) -> DrawInfo? {
        let teamNum = pow(2, CGFloat(layer))
        let teams = (0..<Int(teamNum)).map { $0 + (Int(teamNum) * number) }.filter { !dataStore.excludes.contains($0) }
        if teams.count == 0 { return nil }

        let drawOffset = CGFloat((0..<(number * 2)).filter { !dataStore.excludes.contains($0) }.count)

        let homeDrawInfo = (layer == 1) ?
            getBottomLayerDrawInfo(with: drawOffset) :
            drawRecursively(layer: layer - 1, number: number * 2)

        if !dataStore.style.isHalf && layer == dataStore.numberOfLayers { half = .second }

        let awayDrawInfo = (layer == 1) ?
            getBottomLayerDrawInfo(with: drawOffset + 1) :
            drawRecursively(layer: layer - 1, number: (number * 2) + 1)

        guard let match = getMatch(layer: layer, number: number) else {
            let drawInfo = drawNoMatchLine(layer: layer, number: number, homeDrawInfo: homeDrawInfo, awayDrawInfo: awayDrawInfo)

            if dataStore.style.isHalf || layer != dataStore.numberOfLayers { return drawInfo }

            let crossPoint = homeDrawInfo?.cross ?? awayDrawInfo!.cross
            let homeMatch = getMatch(layer: layer - 1, number: number * 2)
            drawLowLayerLine(drawInfo: homeDrawInfo, crossPoint: crossPoint, match: homeMatch)
            let awayMatch = getMatch(layer: layer - 1, number: number * 2 + 1)
            drawLowLayerLine(drawInfo: awayDrawInfo, crossPoint: crossPoint, match: awayMatch)

            return drawInfo
        }

        let crossPoint = getCrossPoint(layer: layer, homeDrawInfo: homeDrawInfo!, awayDrawInfo: awayDrawInfo!)

        drawBracket(with: crossPoint, homeDrawInfo: homeDrawInfo!, awayDrawInfo: awayDrawInfo!, match: match)
        layoutMatch(match, homeDrawInfo: homeDrawInfo!, awayDrawInfo: awayDrawInfo!)

        return DrawInfo(cross: crossPoint, home: homeDrawInfo!.cross, away: awayDrawInfo!.cross, isFinished: match.preferredSide != nil)
    }

    func drawNoMatchLine(layer: Int, number: Int, homeDrawInfo: DrawInfo?, awayDrawInfo: DrawInfo?) -> DrawInfo {
        var (mutableLayer, mutableNumber) = (layer, number)
        var refMatch: KRTournamentViewMatch?
        while mutableLayer <= dataStore.numberOfLayers && refMatch == nil {
            (mutableLayer, mutableNumber) = (mutableLayer+1, mutableNumber/2)
            refMatch = getMatch(layer: mutableLayer, number: mutableNumber)
        }

        let teamNum = Int(pow(2, CGFloat(mutableLayer)))
        let offset = mutableNumber * teamNum
        let side: MatchPreferredSide = (number * 2 < teamNum / 2 + offset) ? .home : .away
        let drawInfo = homeDrawInfo ?? awayDrawInfo!
        let isFinished = (layer == 1) ? (refMatch != nil && refMatch!.preferredSide == side) : drawInfo.isFinished

        let point: CGPoint
        switch dataStore.style {
        case .left,
             .leftRight where half == .first,
             .leftRight where layer == dataStore.numberOfLayers && homeDrawInfo != nil:
            point = CGPoint(x: drawInfo.cross.x + stepSize.width, y: drawInfo.cross.y)
        case .right, .leftRight:
            point = CGPoint(x: drawInfo.cross.x - stepSize.width, y: drawInfo.cross.y)
        case .top,
             .topBottom where half == .first,
             .topBottom where layer == dataStore.numberOfLayers && homeDrawInfo != nil:
            point = CGPoint(x: drawInfo.cross.x, y: drawInfo.cross.y + stepSize.height)
        case .bottom, .topBottom:
            point = CGPoint(x: drawInfo.cross.x, y: drawInfo.cross.y - stepSize.height)
        }

        let bezierPath = getBezierPath(usingPreferredColor: isFinished)
        bezierPath.move(to: CGPoint(x: drawInfo.cross.x, y: drawInfo.cross.y))
        bezierPath.addLine(to: point)

        return DrawInfo(cross: point, home: drawInfo.cross, away: drawInfo.cross, isFinished: isFinished)
    }

    func drawBracket(with crossPoint: CGPoint, homeDrawInfo: DrawInfo, awayDrawInfo: DrawInfo, match: KRTournamentViewMatch) {
        switch dataStore.style {
        case .leftRight where match.matchPath.layer == dataStore.numberOfLayers,
             .topBottom where match.matchPath.layer == dataStore.numberOfLayers:
            let homeMatch = getMatch(layer: match.matchPath.layer - 1, number: match.matchPath.number * 2)
            drawLowLayerLine(drawInfo: homeDrawInfo, crossPoint: crossPoint, match: homeMatch)
            drawFinalMatchBracket(drawInfo: homeDrawInfo, crossPoint: crossPoint, usingPreferredColor: match.preferredSide == .home)

            let awayMatch = getMatch(layer: match.matchPath.layer - 1, number: match.matchPath.number * 2 + 1)
            drawLowLayerLine(drawInfo: awayDrawInfo, crossPoint: crossPoint, match: awayMatch)
            drawFinalMatchBracket(drawInfo: awayDrawInfo, crossPoint: crossPoint, usingPreferredColor: match.preferredSide == .away)

        case .left, .right, .top, .bottom, .leftRight, .topBottom:
            drawSimpleBracket(drawInfo: homeDrawInfo, crossPoint: crossPoint, match: match, preferredSide: .home)
            drawSimpleBracket(drawInfo: awayDrawInfo, crossPoint: crossPoint, match: match, preferredSide: .away)
        }
    }

    func drawSimpleBracket(drawInfo: DrawInfo, crossPoint: CGPoint, match: KRTournamentViewMatch, preferredSide side: MatchPreferredSide) {
        let cornerPoint = (dataStore.style.isVertical) ?
            CGPoint(x: crossPoint.x, y: drawInfo.cross.y) :
            CGPoint(x: drawInfo.cross.x, y: crossPoint.y)

        var path = getBezierPath(usingPreferredColor: (match.matchPath.layer == 1) ? match.preferredSide == side : drawInfo.isFinished)
        path.move(to: drawInfo.cross)
        path.addLine(to: cornerPoint)

        guard dataStore.style.isHalf || match.matchPath.layer != dataStore.numberOfLayers - 1 else { return }

        path = getBezierPath(usingPreferredColor: match.preferredSide == side)
        path.move(to: cornerPoint)
        path.addLine(to: crossPoint)
    }

    func drawLowLayerLine(drawInfo: DrawInfo?, crossPoint: CGPoint, match: KRTournamentViewMatch?) {
        guard let match = match, let drawInfo = drawInfo else { return }

        let isInRange = (dataStore.style.isVertical) ?
            drawInfo.home.y + 10 < crossPoint.y && crossPoint.y < drawInfo.away.y - 10 :
            drawInfo.home.x + 10 < crossPoint.x && crossPoint.x < drawInfo.away.x - 10

        var path = getBezierPath(usingPreferredColor: match.preferredSide == .home)
        if dataStore.style.isVertical {
            path.move(to: CGPoint(x: drawInfo.cross.x, y: drawInfo.home.y))
            path.addLine(to: CGPoint(x: drawInfo.cross.x, y: isInRange ? crossPoint.y : drawInfo.cross.y))
        } else {
            path.move(to: CGPoint(x: drawInfo.home.x, y: drawInfo.cross.y))
            path.addLine(to: CGPoint(x: isInRange ? crossPoint.x : drawInfo.cross.x, y: drawInfo.cross.y))
        }

        path = getBezierPath(usingPreferredColor: match.preferredSide == .away)
        if dataStore.style.isVertical {
            path.move(to: CGPoint(x: drawInfo.cross.x, y: drawInfo.away.y))
            path.addLine(to: CGPoint(x: drawInfo.cross.x, y: isInRange ? crossPoint.y : drawInfo.cross.y))
        } else {
            path.move(to: CGPoint(x: drawInfo.away.x, y: drawInfo.cross.y))
            path.addLine(to: CGPoint(x: isInRange ? crossPoint.x : drawInfo.cross.x, y: drawInfo.cross.y))
        }
    }

    func drawFinalMatchBracket(drawInfo: DrawInfo, crossPoint: CGPoint, usingPreferredColor using: Bool) {
        func draw(additional: CGFloat) {
            let path = getBezierPath(usingPreferredColor: using)
            if dataStore.style.isVertical {
                path.move(to: CGPoint(x: drawInfo.cross.x + additional, y: crossPoint.y))
            } else {
                path.move(to: CGPoint(x: crossPoint.x, y: drawInfo.cross.y + additional))
            }
            path.addLine(to: crossPoint)
        }

        let isInRange = (dataStore.style.isVertical) ?
            drawInfo.home.y + 10 < crossPoint.y && crossPoint.y < drawInfo.away.y - 10 :
            drawInfo.home.x + 10 < crossPoint.x && crossPoint.x < drawInfo.away.x - 10

        if isInRange {
            return draw(additional: 0)
        }

        let additional: CGFloat
        let path = getBezierPath(usingPreferredColor: using)
        path.move(to: drawInfo.cross)
        if dataStore.style.isVertical {
            additional = (drawInfo.cross.x < crossPoint.x) ? 10 : -10
            path.addLine(to: CGPoint(x: drawInfo.cross.x + additional, y: drawInfo.cross.y))
            path.addLine(to: CGPoint(x: drawInfo.cross.x + additional, y: crossPoint.y))
        } else {
            additional = (drawInfo.cross.y < crossPoint.y) ? 10 : -10
            path.addLine(to: CGPoint(x: drawInfo.cross.x, y: drawInfo.cross.y + additional))
            path.addLine(to: CGPoint(x: crossPoint.x, y: drawInfo.cross.y + additional))
        }

        draw(additional: additional)
    }
}

// MARK: - Action -------------------

private extension KRTournamentDrawingView {
    func layoutMatch(_ match: KRTournamentViewMatch, homeDrawInfo: DrawInfo, awayDrawInfo: DrawInfo) {
        let crossPoint = getCrossPoint(layer: match.matchPath.layer, homeDrawInfo: homeDrawInfo, awayDrawInfo: awayDrawInfo)
        let homeMatch = getMatch(layer: match.matchPath.layer - 1, number: match.matchPath.number * 2)
        let awayMatch = getMatch(layer: match.matchPath.layer - 1, number: match.matchPath.number * 2 + 1)

        switch dataStore.style {
        case .leftRight where match.matchPath.layer == dataStore.numberOfLayers:
            match.frame.size = CGSize(width: stepSize.width, height: 50)
            homeMatch?.updateImageViewCenter(CGPoint(x: homeDrawInfo.cross.x, y: crossPoint.y))
            awayMatch?.updateImageViewCenter(CGPoint(x: awayDrawInfo.cross.x, y: crossPoint.y))
        case .topBottom where match.matchPath.layer == dataStore.numberOfLayers:
            match.frame.size = CGSize(width: 50, height: stepSize.height)
            homeMatch?.updateImageViewCenter(CGPoint(x: crossPoint.x, y: homeDrawInfo.cross.y))
            awayMatch?.updateImageViewCenter(CGPoint(x: crossPoint.x, y: awayDrawInfo.cross.y))
        case .left, .right, .leftRight:
            match.frame.size = CGSize(width: stepSize.width, height: awayDrawInfo.cross.y - homeDrawInfo.cross.y + 10)
        case .bottom, .top, .topBottom:
            match.frame.size = CGSize(width: awayDrawInfo.cross.x - homeDrawInfo.cross.x + 10, height: stepSize.height)
        }

        match.center = crossPoint
        addSubview(match)
    }
}
