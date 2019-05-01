//
//  KRTournamentDrawingView.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

class KRTournamentDrawingView: UIView {
    private weak var dataStore: KRTournamentViewDataStore!

    var lineColor: UIColor = Default.lineColor
    var preferredLineColor: UIColor = Default.preferredLineColor
    var lineWidth: CGFloat = Default.lineWidth
    var preferredLineWidth: CGFloat?

    var matches = [KRTournamentViewMatch]() {
        willSet { matches.forEach { $0.removeFromSuperview() } }
    }

    convenience init(dataStore: KRTournamentViewDataStore) {
        self.init(frame: .zero)
        self.dataStore = dataStore
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let pathSet = getPath()

        lineColor.setStroke()
        pathSet.path.lineWidth = lineWidth
        pathSet.path.lineCapStyle = .square
        pathSet.path.stroke()

        preferredLineColor.setStroke()
        pathSet.winnerPath.lineWidth = preferredLineWidth ?? lineWidth
        pathSet.winnerPath.lineCapStyle = .square
        pathSet.winnerPath.stroke()

        matches.forEach { match in
            match.backgroundColor = UIColor.green.withAlphaComponent(0.2)
            if match.matchPath.layer == dataStore.tournamentStructure.matchPath.layer - 1 {
                match.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
            }
            match.layer.borderWidth = 1
            match.layer.borderColor = UIColor.green.withAlphaComponent(0.5).cgColor
            addSubview(match)
        }
    }

    private func getPath() -> PathSet {
        let drawHalf: DrawHalf = {
            switch dataStore.style {
            case .left, .top, .leftRight, .topBottom: return .first
            case .right, .bottom: return .second
            }
        }()

        return dataStore.tournamentStructure.getPath(with: .init(
            structure: dataStore.tournamentStructure,
            style: dataStore.style,
            drawHalf: drawHalf,
            rect: bounds,
            entrySize: dataStore.entrySize
        )) { matchPath, frame, points in
            guard let match = matches.first(where: { $0.matchPath == matchPath }) else { return }
            match.frame = frame
            match.winnerPoints = points
        }
    }
}

struct PathSet {
    let path: UIBezierPath
    let winnerPath: UIBezierPath

    subscript(needsWinnerPath: Bool) -> UIBezierPath {
        return needsWinnerPath ? winnerPath : path
    }

    init(path: UIBezierPath = .init(), winnerPath: UIBezierPath = .init()) {
        self.path = path
        self.winnerPath = winnerPath
    }

    func append(_ pathSet: PathSet) {
        path.append(pathSet.path)
        winnerPath.append(pathSet.winnerPath)
    }
}

private extension Bracket {
    typealias BracketHandler = (MatchPath, CGRect, [CGPoint]) -> Void
    func getPath(with info: TournamentInfo, handler: BracketHandler) -> PathSet {
        return innerGetPath(with: info, handler: handler).pathSet
    }
}

private extension Bracket {
    typealias PointInfo = (point: CGPoint, isDecided: Bool)
    typealias GrandChildInfo = (start: CGPoint, end: CGPoint, wonEntryPoints: [CGPoint], numberOfEntry: Int, numberOfWinner: Int)
    typealias ChildInfo = (matchPath: MatchPath, childInfo: GrandChildInfo)
    typealias Results = (pathSet: PathSet, childInfo: ChildInfo?)

    private func innerGetPath(with info: TournamentInfo, handler: BracketHandler) -> Results {
        let (pathSet, childInfos) = getChildPaths(info: info, handler: handler)
        var ownChildInfo: ChildInfo!

        switch info.style {
        case .leftRight where info.numberOfLayer == matchPath.layer,
             .topBottom where info.numberOfLayer == matchPath.layer:
            let childInfosBySide = splitChildInfosBySide(childInfos, info: info)
            let centerPoint = getCenterInFinalMatch(firstSide: childInfosBySide[0], secondSide: childInfosBySide[1], info: info)
            var childEntryPoints = [[CGPoint](), [CGPoint]()]
            var winnerCounts = [0, 0]

            // サイドごとに結合
            childInfosBySide.enumerated().forEach { index, childInfos in
                let usingInfo = (index == 0) ? info : info.convert(drawHalf: .second)
                let winnerIndexOffset = (index == 0) ? 0 : childInfosBySide[0].reduce(0) { $0 + $1.childInfo.numberOfWinner }
                let path = getGrandchild2ChildPathInSemiFinal(from: childInfos, centerPoint: centerPoint, winnerIndexOffset: winnerIndexOffset, info: usingInfo, handler: handler)
                pathSet.append(path.pathSet)
                childEntryPoints[index].append(contentsOf: path.entryPoints)
                winnerCounts[index] = path.winnerCount
            }

            // final match
            let subPathSet = getFinalMatchPathInBothSideStyle(info: info, centerPoint: centerPoint, childEntryPoints: childEntryPoints, winnerCounts: winnerCounts, handler: handler)
            pathSet.append(subPathSet)

        case .left, .right, .top, .bottom, .leftRight, .topBottom:
            var (subPathSet, childInfo) = getGrandchild2ChildPath(from: childInfos, info: info, handler: handler)
            pathSet.append(subPathSet)

            if matchPath.layer == info.numberOfLayer {
                (subPathSet, childInfo) = getGrandchild2ChildPath(from: [childInfo], info: info, handler: handler)
                pathSet.append(subPathSet)
            }

            ownChildInfo = childInfo
        }

        return (pathSet, ownChildInfo)
    }

    private func splitChildInfosBySide(_ childInfos: [ChildInfo], info: TournamentInfo) -> [[ChildInfo]] {
        let centerPosition = info.rect.size.length(in: info.style, direction: .layer) / 2
        var childInfosBySide: [[ChildInfo]] = [[], []]
        childInfos.forEach { childInfo in
            childInfo.childInfo.start.axis(in: info.style, direction: .layer) < centerPosition
                ? childInfosBySide[0].append(childInfo)
                : childInfosBySide[1].append(childInfo)
        }
        return childInfosBySide
    }

    private func getFinalMatchPathInBothSideStyle(info: TournamentInfo, centerPoint: CGPoint, childEntryPoints: [[CGPoint]], winnerCounts: [Int], handler: BracketHandler) -> PathSet {
        let pathSet = PathSet()

        let stepLength = info.stepSize.length(in: info.style, direction: .layer)
        let centerPosition = centerPoint.axis(in: info.style, direction: .layer)
        let startPosition = centerPosition - stepLength / 3
        let endPosition = centerPosition + stepLength / 3
        let entriesCount = childEntryPoints.reduce(0) { $0 + $1.count }
        let winnerStepLength = (endPosition - startPosition) * 0.9 / CGFloat(entriesCount)
        let firstWinnerPoint = centerPoint.replaced(
            to: centerPosition - (winnerStepLength / 2) * CGFloat(numberOfWinner - 1),
            in: info.style,
            direction: .layer
        )
        let winnerPoints = (0..<numberOfWinner).map {
            return firstWinnerPoint.adding(CGFloat($0) * winnerStepLength, to: .layer, style: info.style, drawHalf: .first)
        }

        let hasWinner = winnerCounts.reduce(0, +) > 0
        let startPoint = centerPoint.replaced(to: startPosition, in: info.style, direction: .layer)
        let endPoint = centerPoint.replaced(to: endPosition, in: info.style, direction: .layer)
        let championLength: CGFloat = info.style.isVertical
            ? (info.style.direction == .bottom) ? 20 : -20
            : (info.style.direction == .left) ? -20 : 20
        var currentPoint = startPoint

        winnerPoints.enumerated().forEach { index, winnerPoint in
            pathSet[hasWinner && winnerCounts[0] != index].addLine(from: currentPoint, to: winnerPoint)
            pathSet[winnerIndexes.count != 0].addLine(from: winnerPoint, to: winnerPoint.adding(championLength, toEntryDirectionFor: info.style))
            currentPoint = winnerPoint
        }

        pathSet[winnerCounts[1] > 0].addLine(from: currentPoint, to: endPoint)

        // call handler
        var frame: CGRect {
            let startLayerPosition = info.style.isVertical
                ? centerPoint.x - info.stepSize.width * ((childEntryPoints[0].count == 1) ? 1/2 : 5/6)
                : centerPoint.y - info.stepSize.height * ((childEntryPoints[0].count == 1) ? 1/2 : 5/6)
            let endLayerPosition = info.style.isVertical
                ? centerPoint.x + info.stepSize.width * ((childEntryPoints[1].count == 1) ? 1/2 : 5/6)
                : centerPoint.y + info.stepSize.height * ((childEntryPoints[1].count == 1) ? 1/2 : 5/6)

            let margin = min(10, info.stepSize.length(in: info.style, direction: .entry) / 2)
            let allPoints = childEntryPoints.flatMap { $0 }.sorted {
                $0.axis(in: info.style, direction: .entry) < $1.axis(in: info.style, direction: .entry)
            }
            let startEntryPosition = min(
                allPoints.first!.axis(in: info.style, direction: .entry) - margin,
                centerPoint.axis(in: info.style, direction: .entry) - abs(championLength)
            )
            let endEntryPosition = max(
                allPoints.last!.axis(in: info.style, direction: .entry) + margin,
                centerPoint.axis(in: info.style, direction: .entry) + abs(championLength)
            )

            return info.style.isVertical
                ? .init(
                    x: startLayerPosition,
                    y: startEntryPosition,
                    width: endLayerPosition - startLayerPosition,
                    height: endEntryPosition - startEntryPosition
                    )
                : .init(
                    x: startEntryPosition,
                    y: startLayerPosition,
                    width: endEntryPosition - startEntryPosition,
                    height: endLayerPosition - startLayerPosition
            )
        }
        handler(matchPath, frame, winnerPoints)

        return pathSet
    }

    private func getGrandchild2ChildPathInSemiFinal(from childInfos: [ChildInfo], centerPoint: CGPoint, winnerIndexOffset: Int, info: TournamentInfo, handler: BracketHandler) -> (pathSet: PathSet, entryPoints: [CGPoint], winnerCount: Int) {
        let pathSet = PathSet()
        var childEntryPoints = [CGPoint]()
        var winnerPoints = [CGPoint]()

        let layerLength = info.stepSize.length(in: info.style, direction: .layer) / 3
        let entryCenterPoint = centerPoint.adding(-layerLength, to: .layer, style: info.style, drawHalf: info.drawHalf)
        let junctionCenterPoint = entryCenterPoint.adding(-layerLength, to: .layer, style: info.style, drawHalf: info.drawHalf)
        let grandchildCenterPoint = (childInfos.count > 1) ? nil : centerPoint

        childInfos.forEach { arg in
            let (childMatchPath, grandchildInfo) = arg
            let (childPathSet, entryPoints) = getEntry2EntryPath(from: grandchildInfo, style: info.style, preferredCenter: grandchildCenterPoint)
            let points = entryPoints.map { $0.0 }

            pathSet.append(childPathSet)

            points.forEach { point in
                let entryPoint = point.replaced(to: junctionCenterPoint, in: info.style, direction: .layer)
                let isWin = winnerIndexes.contains(winnerIndexOffset + childEntryPoints.count)
                pathSet[isWin].addLine(from: point, to: entryPoint)

                childEntryPoints.append(entryPoint)
                if isWin { winnerPoints.append(entryPoint) }
            }

            if grandchildInfo.numberOfEntry == 1 { return }

            // call handler
            var frame: CGRect {
                if childEntryPoints.count == 1 {
                    return .bracketRect(with: info, start: grandchildInfo.start, end: grandchildInfo.end)
                }
                let margin = min(10, info.stepSize.length(in: info.style, direction: .entry) / 2)
                return info.style.isVertical
                    ? .init(
                        x: grandchildInfo.start.x - info.stepSize.width / ((info.drawHalf == .first) ? 2 : 6),
                        y: grandchildInfo.start.y - margin,
                        width: info.stepSize.width * 2 / 3,
                        height: (grandchildInfo.end.y - grandchildInfo.start.y) + margin * 2
                        )
                    : .init(
                        x: grandchildInfo.start.x - margin,
                        y: grandchildInfo.start.y - info.stepSize.height / ((info.drawHalf == .first) ? 2 : 6),
                        width: (grandchildInfo.end.x - grandchildInfo.start.x) + margin * 2,
                        height: info.stepSize.height * 2 / 3
                )
            }
            handler(childMatchPath, frame, points)
        }

        // join childInfos

        let grandchildInfo = GrandChildInfo(
            start: childEntryPoints.first!,
            end: childEntryPoints.last!,
            wonEntryPoints: winnerPoints,
            numberOfEntry: childEntryPoints.count,
            numberOfWinner: 1
        )
        let (junctionPathSet, junctionPoints) = getEntry2EntryPath(from: grandchildInfo, style: info.style, preferredCenter: centerPoint)

        pathSet.append(junctionPathSet)

        let junctionPoint = junctionPoints.first!.point
        let cornerPoint = junctionPoint.replaced(to: entryCenterPoint, in: info.style, direction: .layer)

        pathSet[winnerPoints.count > 0].addLine(from: junctionPoint, to: cornerPoint)
        pathSet[winnerPoints.count > 0].addLine(to: entryCenterPoint)

        return (pathSet, childEntryPoints, winnerPoints.count)
    }

    private func getGrandchild2ChildPath(from childInfos: [ChildInfo], info: TournamentInfo, handler: BracketHandler) -> (pathSet: PathSet, childInfo: ChildInfo) {
        let pathSet = PathSet()
        var startPoint: CGPoint!
        var endPoint: CGPoint!
        var wonPoints = [CGPoint]()
        var numberOfChildWinners = 0

        childInfos.forEach { childMatchPath, grandchildInfo in
            // grandchild <-> child の entry 方向
            let (childPathSet, points) = getEntry2EntryPath(from: grandchildInfo, style: info.style)
            pathSet.append(childPathSet)

            // child <-> self の layer 方向の線
            points.forEach { point, isDecided in
                let length = info.stepSize.length(in: info.style, direction: .layer) * CGFloat(max(1, matchPath.layer - childMatchPath.layer))
                let toPoint = point.adding(length, to: .layer, style: info.style, drawHalf: info.drawHalf)

                if (matchPath.layer == info.numberOfLayer) && (grandchildInfo.numberOfEntry == 1) {
                    pathSet[winnerIndexes.contains(numberOfChildWinners)].addLine(from: point, to: toPoint)
                } else {
                    pathSet[isDecided].addLine(from: point, to: toPoint)
                }

                if startPoint == nil { startPoint = toPoint }
                endPoint = toPoint

                if winnerIndexes.contains(numberOfChildWinners) {
                    wonPoints.append(toPoint)
                }
                numberOfChildWinners += 1
            }

            if grandchildInfo.numberOfEntry == 1 { return }

            // call handler
            let frame = CGRect.bracketRect(with: info, start: grandchildInfo.start, end: grandchildInfo.end)
            handler(childMatchPath, frame, points.map { $0.0 })
        }

        let grandchildInfo = GrandChildInfo(startPoint, endPoint, wonPoints, numberOfChildWinners, numberOfWinner)
        return (pathSet, ChildInfo(matchPath, grandchildInfo))
    }

    private func getChildPaths(info: TournamentInfo, handler: BracketHandler) -> (pathSet: PathSet, childInfos: [ChildInfo]) {
        let pathSet = PathSet()
        let isFinalLayer = info.numberOfLayer == matchPath.layer
        let halfThreshold = info.style.isHalf ? children.count : (children.count / 2)

        let childInfos = children.enumerated().compactMap { index, child -> ChildInfo? in
            let childInfo = (isFinalLayer && index >= halfThreshold) ? info.convert(drawHalf: .second) : info

            if let bracket = child as? Bracket {
                let result = bracket.innerGetPath(with: childInfo, handler: handler)
                pathSet.append(result.pathSet)
                return result.childInfo
            }

            if let entry = child as? Entry {
                let entryPoint = childInfo.entryPoint(at: entry.index)
                let isWin = winnerIndexes.contains(index)
                return (.init(layer: 0, number: -1), (entryPoint, entryPoint, isWin ? [entryPoint] : [], 1, 1))
            }

            return nil
        }

        return (pathSet, childInfos)
    }

    private func getEntry2EntryPath(from grandchildInfo: GrandChildInfo, style: KRTournamentViewStyle, preferredCenter: CGPoint? = nil) -> (pathSet: PathSet, winnerPoints: [PointInfo]) {
        let winnerPoints = getWinnerPoints(from: grandchildInfo, style: style, preferredCenter: preferredCenter)
        let (path, winnerPath) = UIBezierPath.initDouble()
        var wonPoints = [CGPoint]()

        if grandchildInfo.start == grandchildInfo.end {
            return (
                .init(path: path, winnerPath: winnerPath),
                [(grandchildInfo.start, grandchildInfo.wonEntryPoints.count != 0)]
            )
        }

        path.move(to: grandchildInfo.start)

        grandchildInfo.wonEntryPoints.forEach { point in
            let entryPosition = point.axis(in: style, direction: .entry)
            let winnerPoint = winnerPoints.filter { !wonPoints.contains($0) }.min {
                abs($0.axis(in: style, direction: .entry) - entryPosition) < abs($1.axis(in: style, direction: .entry) - entryPosition)
                } ?? wonPoints.last!
            wonPoints.append(winnerPoint)

            winnerPath.addLine(from: point, to: winnerPoint)

            let points = [point, winnerPoint].sorted {
                $0.axis(in: style, direction: .entry) < $1.axis(in: style, direction: .entry)
            }
            if path.currentPoint.axis(in: style, direction: .entry) < points[0].axis(in: style, direction: .entry) {
                path.addLine(to: points[0])
            }
            path.move(to: points[1])
        }

        if path.currentPoint != grandchildInfo.end { path.addLine(to: grandchildInfo.end) }

        return (
            .init(path: path, winnerPath: winnerPath),
            winnerPoints.map { ($0, wonPoints.contains($0)) }
        )
    }

    private func getWinnerPoints(from grandchildInfo: GrandChildInfo, style: KRTournamentViewStyle, preferredCenter: CGPoint?) -> [CGPoint] {
        let startPosition = grandchildInfo.start.axis(in: style, direction: .entry)
        let endPosition = grandchildInfo.end.axis(in: style, direction: .entry)
        let stepLength = (endPosition - startPosition) * 0.9 / CGFloat(max(2, grandchildInfo.numberOfEntry - 1))
        let centerPosition: CGFloat = {
            let offset = (stepLength / 2) * CGFloat(grandchildInfo.numberOfWinner - 1)
            let position = preferredCenter?.axis(in: style, direction: .entry)
            if let pos = position, (startPosition + offset) < pos, pos < (endPosition - offset) {
                return pos
            } else {
                return startPosition + ((endPosition - startPosition) / 2)
            }
        }()
        let firstWinnerPoint = grandchildInfo.start.replaced(
            to: centerPosition - (stepLength / 2) * CGFloat(grandchildInfo.numberOfWinner - 1),
            in: style,
            direction: .entry
        )
        return (0..<grandchildInfo.numberOfWinner).map {
            return firstWinnerPoint.adding(CGFloat($0) * stepLength, to: .entry, style: style, drawHalf: .first)
        }
    }

    private func getCenter(between points: [CGPoint]) -> CGPoint {
        var minX = points.first!.x
        var maxX = points.first!.x
        var minY = points.first!.y
        var maxY = points.first!.y

        points.forEach {
            minX = min(minX, $0.x)
            maxX = max(maxX, $0.x)
            minY = min(minY, $0.y)
            maxY = max(maxY, $0.y)
        }

        return .init(x: minX + (maxX - minX) / 2, y: minY + (maxY - minY) / 2)
    }

    private func getCenterInFinalMatch(firstSide fChildInfos: [ChildInfo], secondSide sChildInfos: [ChildInfo], info: TournamentInfo) -> CGPoint {
        let rectCenter = CGPoint(x: info.rect.midX, y: info.rect.midY)
        let centerPosition = rectCenter.axis(in: info.style, direction: .entry)

        let firstSideStartPoint = fChildInfos.first!.childInfo.start
        let firstSideEndPoint = fChildInfos.last!.childInfo.end
        let firstSideCenterPoint = getCenter(between: [firstSideStartPoint, firstSideEndPoint])

        let secondSideStartPoint = sChildInfos.first!.childInfo.start
        let secondSideEndPoint = sChildInfos.last!.childInfo.end
        let secondSideCenterPoint = getCenter(between: [secondSideStartPoint, secondSideEndPoint])

        if firstSideStartPoint.axis(in: info.style, direction: .entry) < centerPosition &&
            firstSideEndPoint.axis(in: info.style, direction: .entry) > centerPosition &&
            secondSideStartPoint.axis(in: info.style, direction: .entry) < centerPosition &&
            secondSideEndPoint.axis(in: info.style, direction: .entry) > centerPosition {
            return rectCenter
        }

        let center = getCenter(between: [firstSideCenterPoint, secondSideCenterPoint])
        return rectCenter.replaced(to: center, in: info.style, direction: .entry)
    }
}

private extension UIBezierPath {
    static func initDouble() -> (UIBezierPath, UIBezierPath) { return (.init(), .init()) }

    func addLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        move(to: fromPoint)
        addLine(to: toPoint)
    }
}

private enum Direction { case layer, entry }

private extension CGPoint {
    func axis(in style: KRTournamentViewStyle, direction: Direction) -> CGFloat {
        return (style.isVertical == (direction == .layer)) ? x : y
    }

    func replaced(to length: CGFloat, in style: KRTournamentViewStyle, direction: Direction) -> CGPoint {
        return (style.isVertical == (direction == .layer))
            ? .init(x: length, y: y)
            : .init(x: x, y: length)
    }

    func replaced(to point: CGPoint, in style: KRTournamentViewStyle, direction: Direction) -> CGPoint {
        return (style.isVertical == (direction == .layer))
            ? replaced(to: point.x, in: style, direction: direction)
            : replaced(to: point.y, in: style, direction: direction)
    }

    // swiftlint:disable identifier_name
    func adding(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        return .init(x: self.x + x, y: self.y + y)
    }
    // swiftlint:enable identifier_name

    func adding(_ length: CGFloat, toEntryDirectionFor style: KRTournamentViewStyle) -> CGPoint {
        return style.isVertical ? adding(y: length) : adding(x: length)
    }

    func adding(_ length: CGFloat, to direction: Direction, style: KRTournamentViewStyle, drawHalf: DrawHalf) -> CGPoint {
        if direction == .entry { return adding(length, toEntryDirectionFor: style) }

        switch style {
        case .left,
             .leftRight where drawHalf == .first:
            return adding(x: length)
        case .right, .leftRight:
            return adding(x: -length)
        case .top,
             .topBottom where drawHalf == .first:
            return adding(y: length)
        case .bottom, .topBottom:
            return adding(y: -length)
        }
    }
}

private extension CGSize {
    func length(in style: KRTournamentViewStyle, direction: Direction) -> CGFloat {
        return (style.isVertical == (direction == .layer)) ? width : height
    }
}

private extension CGRect {
    static func bracketRect(with info: TournamentInfo, start: CGPoint, end: CGPoint, margin: CGFloat = 10) -> CGRect {
        let margin = min(margin, info.stepSize.length(in: info.style, direction: .entry) / 2)
        return info.style.isVertical
            ? .init(
                origin: start.adding(x: -info.stepSize.width / 2, y: -margin),
                size: .init(width: info.stepSize.width, height: (end.y - start.y) + margin * 2)
                )
            : .init(
                origin: start.adding(x: -margin, y: -info.stepSize.height / 2),
                size: .init(width: (end.x - start.x) + margin * 2, height: info.stepSize.height)
        )
    }
}
