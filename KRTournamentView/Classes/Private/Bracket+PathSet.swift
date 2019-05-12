//
//  Bracket+PathSet.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//
//  swiftlint:disable large_tuple

import UIKit

extension Bracket {
    /// (MatchPath, rect of bracket, cross points of winner's line)
    typealias BracketHandler = (MatchPath, CGRect, [CGPoint]) -> Void

    func getPath(with info: TournamentInfo, handler: BracketHandler) -> PathSet {
        return innerGetPath(with: info, handler: handler).pathSet
    }
}

// MARK: - Private actions ------------

private extension Bracket {
    typealias PointInfo = (point: CGPoint, isDecided: Bool)
    typealias GrandChildInfo = (start: CGPoint, end: CGPoint, wonEntryPoints: [CGPoint], numberOfEntry: Int, numberOfWinner: Int)
    typealias ChildInfo = (matchPath: MatchPath, childInfo: GrandChildInfo)

    func innerGetPath(with info: TournamentInfo, handler: BracketHandler) -> (pathSet: PathSet, childInfo: ChildInfo?) {
        let (pathSet, childInfos) = getChildPaths(info: info, handler: handler)
        var ownChildInfo: ChildInfo!

        switch info.style {
        case .leftRight where info.numberOfLayer == matchPath.layer,
             .topBottom where info.numberOfLayer == matchPath.layer:
            let childInfosBySide = splitChildInfosBySide(childInfos, info: info)
            let centerPoint = getCenterInFinalMatch(firstSide: childInfosBySide[0], secondSide: childInfosBySide[1], info: info)
            var childEntryPoints = [[CGPoint](), [CGPoint]()]
            var winnerCounts = [0, 0]

            // join by side
            childInfosBySide.enumerated().forEach { index, childInfos in
                let usingInfo = (index == 0) ? info : info.convert(drawHalf: .second)
                let winnerIndexOffset = (index == 0) ? 0 : childInfosBySide[0].reduce(0) { $0 + $1.childInfo.numberOfWinner }
                let path = getGrandchild2ChildPathInSemiFinal(from: childInfos, centerPoint: centerPoint, winnerIndexOffset: winnerIndexOffset, info: usingInfo, handler: handler)
                pathSet.append(path.pathSet)
                childEntryPoints[index].append(contentsOf: path.entryPoints)
                winnerCounts[index] = path.winnerCount
            }

            // final match
            let finalMatchPathSet = getFinalMatchPathInBothSideStyle(
                info: info,
                centerPoint: centerPoint,
                childEntryPoints: childEntryPoints,
                winnerCounts: winnerCounts,
                handler: handler
            )
            pathSet.append(finalMatchPathSet)

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

    func getChildPaths(info: TournamentInfo, handler: BracketHandler) -> (pathSet: PathSet, childInfos: [ChildInfo]) {
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
                return (.init(layer: 0, item: -1), (entryPoint, entryPoint, isWin ? [entryPoint] : [], 1, 1))
            }

            return nil
        }

        return (pathSet, childInfos)
    }

    func getGrandchild2ChildPath(from childInfos: [ChildInfo], info: TournamentInfo, handler: BracketHandler) -> (pathSet: PathSet, childInfo: ChildInfo) {
        let pathSet = PathSet()
        var startPoint: CGPoint!
        var endPoint: CGPoint!
        var wonPoints = [CGPoint]()
        var numberOfChildWinners = 0

        childInfos.forEach { childMatchPath, grandchildInfo in
            // path of entry direction between grandchild and child
            let (childPathSet, points) = getEntry2EntryPath(from: grandchildInfo, style: info.style)
            pathSet.append(childPathSet)

            // path of layer direction between child of self
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
            let framePoints = points.map { $0.0.adding(x: -frame.origin.x, y: -frame.origin.y) }
            handler(childMatchPath, frame, framePoints)
        }

        let grandchildInfo = GrandChildInfo(startPoint, endPoint, wonPoints, numberOfChildWinners, numberOfWinners)
        return (pathSet, ChildInfo(matchPath, grandchildInfo))
    }

    func getEntry2EntryPath(from grandchildInfo: GrandChildInfo, style: KRTournamentViewStyle, preferredCenter: CGPoint? = nil) -> (pathSet: PathSet, winnerPoints: [PointInfo]) {
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

    func getWinnerPoints(from grandchildInfo: GrandChildInfo, style: KRTournamentViewStyle, preferredCenter: CGPoint?) -> [CGPoint] {
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
}

// MARK: - Private actions for final match in both side style ------------

private extension Bracket {
    func splitChildInfosBySide(_ childInfos: [ChildInfo], info: TournamentInfo) -> [[ChildInfo]] {
        let centerPosition = info.rect.size.length(in: info.style, direction: .layer) / 2
        var childInfosBySide: [[ChildInfo]] = [[], []]
        childInfos.forEach { childInfo in
            childInfo.childInfo.start.axis(in: info.style, direction: .layer) < centerPosition
                ? childInfosBySide[0].append(childInfo)
                : childInfosBySide[1].append(childInfo)
        }
        return childInfosBySide
    }

    func getCenterInFinalMatch(firstSide fChildInfos: [ChildInfo], secondSide sChildInfos: [ChildInfo], info: TournamentInfo) -> CGPoint {
        let rectCenter = CGPoint(x: info.rect.midX, y: info.rect.midY)
        let centerPosition = rectCenter.axis(in: info.style, direction: .entry)

        let firstSideStartPoint = fChildInfos.first!.childInfo.start
        let firstSideEndPoint = fChildInfos.last!.childInfo.end
        let firstSideCenterPoint = [firstSideStartPoint, firstSideEndPoint].centerPoint

        let secondSideStartPoint = sChildInfos.first!.childInfo.start
        let secondSideEndPoint = sChildInfos.last!.childInfo.end
        let secondSideCenterPoint = [secondSideStartPoint, secondSideEndPoint].centerPoint

        if firstSideStartPoint.axis(in: info.style, direction: .entry) < centerPosition &&
            firstSideEndPoint.axis(in: info.style, direction: .entry) > centerPosition &&
            secondSideStartPoint.axis(in: info.style, direction: .entry) < centerPosition &&
            secondSideEndPoint.axis(in: info.style, direction: .entry) > centerPosition {
            return rectCenter
        }

        let center = [firstSideCenterPoint, secondSideCenterPoint].centerPoint
        return rectCenter.replaced(to: center, in: info.style, direction: .entry)
    }

    func getGrandchild2ChildPathInSemiFinal(from childInfos: [ChildInfo], centerPoint: CGPoint, winnerIndexOffset: Int, info: TournamentInfo, handler: BracketHandler) -> (pathSet: PathSet, entryPoints: [CGPoint], winnerCount: Int) {
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
                if childEntryPoints.count == 1 { return .bracketRect(with: info, start: grandchildInfo.start, end: grandchildInfo.end) }

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
            let framePoints = points.map { $0.adding(x: -frame.origin.x, y: -frame.origin.y) }
            handler(childMatchPath, frame, framePoints)
        }

        let joinedPath = getChildJoinedPathForFinal(
            from: info, entryPoints: childEntryPoints, winnerPoints: winnerPoints,
            centerPoint: centerPoint, entryCenterPoint: entryCenterPoint
        )
        pathSet.append(joinedPath)

        return (pathSet, childEntryPoints, winnerPoints.count)
    }

    func getChildJoinedPathForFinal(from info: TournamentInfo, entryPoints: [CGPoint], winnerPoints: [CGPoint], centerPoint: CGPoint, entryCenterPoint: CGPoint) -> PathSet {
        let pathSet = PathSet()

        let grandchildInfo = GrandChildInfo(
            start: entryPoints.first!,
            end: entryPoints.last!,
            wonEntryPoints: winnerPoints,
            numberOfEntry: entryPoints.count,
            numberOfWinner: 1
        )
        let (junctionPathSet, junctionPoints) = getEntry2EntryPath(from: grandchildInfo, style: info.style, preferredCenter: centerPoint)

        pathSet.append(junctionPathSet)

        let junctionPoint = junctionPoints.first!.point
        let cornerPoint = junctionPoint.replaced(to: entryCenterPoint, in: info.style, direction: .layer)

        pathSet[winnerPoints.count > 0].addLine(from: junctionPoint, to: cornerPoint)
        pathSet[winnerPoints.count > 0].addLine(to: entryCenterPoint)

        return pathSet
    }

    func getFinalMatchPathInBothSideStyle(info: TournamentInfo, centerPoint: CGPoint, childEntryPoints: [[CGPoint]], winnerCounts: [Int], handler: BracketHandler) -> PathSet {
        let pathSet = PathSet()

        let stepLength = info.stepSize.length(in: info.style, direction: .layer)
        let centerPosition = centerPoint.axis(in: info.style, direction: .layer)
        let startPosition = centerPosition - stepLength / 3
        let endPosition = centerPosition + stepLength / 3
        let entriesCount = childEntryPoints.reduce(0) { $0 + $1.count }
        let winnerStepLength = (endPosition - startPosition) * 0.9 / CGFloat(entriesCount)
        let firstWinnerPoint = centerPoint.replaced(
            to: centerPosition - (winnerStepLength / 2) * CGFloat(numberOfWinners - 1),
            in: info.style,
            direction: .layer
        )
        let winnerPoints = (0..<numberOfWinners).map {
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
        let frame = getRectOfFinalMatch(from: info, entryPoints: childEntryPoints, center: centerPoint, championLength: championLength)
        let framePoints = winnerPoints.map { $0.adding(x: -frame.origin.x, y: -frame.origin.y) }
        handler(matchPath, frame, framePoints)

        return pathSet
    }

    func getRectOfFinalMatch(from info: TournamentInfo, entryPoints: [[CGPoint]], center: CGPoint, championLength: CGFloat) -> CGRect {
        let startLayerPosition = info.style.isVertical
            ? center.x - info.stepSize.width * ((entryPoints[0].count == 1) ? 1/2 : 5/6)
            : center.y - info.stepSize.height * ((entryPoints[0].count == 1) ? 1/2 : 5/6)
        let endLayerPosition = info.style.isVertical
            ? center.x + info.stepSize.width * ((entryPoints[1].count == 1) ? 1/2 : 5/6)
            : center.y + info.stepSize.height * ((entryPoints[1].count == 1) ? 1/2 : 5/6)

        let margin = min(10, info.stepSize.length(in: info.style, direction: .entry) / 2)
        let allPoints = entryPoints.flatMap { $0 }.sorted {
            $0.axis(in: info.style, direction: .entry) < $1.axis(in: info.style, direction: .entry)
        }
        let startEntryPosition = min(
            allPoints.first!.axis(in: info.style, direction: .entry) - margin,
            center.axis(in: info.style, direction: .entry) - abs(championLength)
        )
        let endEntryPosition = max(
            allPoints.last!.axis(in: info.style, direction: .entry) + margin,
            center.axis(in: info.style, direction: .entry) + abs(championLength)
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
}

// MARK: - Array<CGPoint> extension ------------

private extension Array where Element == CGPoint {
    var centerPoint: CGPoint {
        if count == 0 { return .zero }

        let firstPoint = first!
        var minX = firstPoint.x
        var maxX = firstPoint.x
        var minY = firstPoint.y
        var maxY = firstPoint.y

        forEach {
            minX = Swift.min(minX, $0.x)
            maxX = Swift.max(maxX, $0.x)
            minY = Swift.min(minY, $0.y)
            maxY = Swift.max(maxY, $0.y)
        }

        return .init(x: minX + (maxX - minX) / 2, y: minY + (maxY - minY) / 2)
    }
}

// MARK: - CGPoint extensions ------------

private extension CGPoint {
    enum Direction { case layer, entry }

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

// MARK: - CGRect extensions ------------

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

// MARK: - CGSize extensions ------------

private extension CGSize {
    enum Direction { case layer, entry }

    func length(in style: KRTournamentViewStyle, direction: Direction) -> CGFloat {
        return (style.isVertical == (direction == .layer)) ? width : height
    }
}

// MARK: - UIBezierPath extensions ------------

private extension UIBezierPath {
    static func initDouble() -> (UIBezierPath, UIBezierPath) { return (.init(), .init()) }

    func addLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        move(to: fromPoint)
        addLine(to: toPoint)
    }
}
