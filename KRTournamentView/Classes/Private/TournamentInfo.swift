//
//  KRTournamentCalculatable.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import UIKit

enum DrawHalf { case first, second }

struct TournamentInfo {
    let numberOfLayer: Int
    let style: KRTournamentViewStyle
    let drawHalf: DrawHalf
    let rect: CGRect
    let firstEntryNum: Int
    let secondEntryNum: Int

    let entrySize: CGSize
    let stepSize: CGSize
    let drawMargin: CGFloat

    // Initializers ------------

    init(
        numberOfLayer: Int,
        style: KRTournamentViewStyle,
        drawHalf: DrawHalf,
        rect: CGRect,
        firstEntryNum: Int,
        secondEntryNum: Int,
        entrySize: CGSize,
        stepSize: CGSize,
        drawMargin: CGFloat
    ) {
        self.numberOfLayer = numberOfLayer
        self.style = style
        self.drawHalf = drawHalf
        self.rect = rect
        self.firstEntryNum = firstEntryNum
        self.secondEntryNum = secondEntryNum
        self.entrySize = entrySize
        self.stepSize = stepSize
        self.drawMargin = drawMargin
    }

    init(
        numberOfLayer: Int,
        style: KRTournamentViewStyle,
        drawHalf: DrawHalf,
        rect: CGRect,
        firstEntryNum: Int,
        secondEntryNum: Int,
        entrySize: CGSize
    ) {
        let entryNum = (drawHalf == .first) ? firstEntryNum : secondEntryNum

        let entrySize: CGSize = {
            let length = style.isVertical ? entrySize.height : entrySize.width
            let frameLength = style.isVertical ? rect.height : rect.width
            let maxLength = frameLength / max(CGFloat(entryNum), 1)
            return style.isVertical ?
                .init(width: entrySize.width, height: min(length, maxLength)) :
                .init(width: min(length, maxLength), height: entrySize.height)
        }()

        let drawMargin = style.isVertical ? entrySize.height / 2 : entrySize.width / 2

        let stepSize: CGSize = {
            let layers = style.isHalf ? numberOfLayer + 1 : numberOfLayer * 2
            return style.isVertical
                ? .init(
                    width: rect.width / CGFloat(layers),
                    height: (rect.height - entrySize.height) / max(CGFloat(entryNum - 1), 1)
                    )
                : .init(
                    width: (rect.width - entrySize.width) / max(CGFloat(entryNum - 1), 1),
                    height: rect.height / CGFloat(layers)
            )
        }()

        self.init(
            numberOfLayer: numberOfLayer,
            style: style,
            drawHalf: drawHalf,
            rect: rect,
            firstEntryNum: firstEntryNum,
            secondEntryNum: secondEntryNum,
            entrySize: entrySize,
            stepSize: stepSize,
            drawMargin: drawMargin
        )
    }

    init(structure: Bracket, style: KRTournamentViewStyle, drawHalf: DrawHalf, rect: CGRect, entrySize: CGSize) {
        self.init(
            numberOfLayer: structure.matchPath.layer,
            style: style,
            drawHalf: drawHalf,
            rect: rect,
            firstEntryNum: structure.entries(style: style, drawHalf: .first).count,
            secondEntryNum: structure.entries(style: style, drawHalf: .second).count,
            entrySize: entrySize
        )
    }
}

// MARK: - Actions ------------

extension TournamentInfo {
    func convert(drawHalf: DrawHalf) -> TournamentInfo {
        return .init(
            numberOfLayer: numberOfLayer,
            style: style,
            drawHalf: drawHalf,
            rect: rect,
            firstEntryNum: firstEntryNum,
            secondEntryNum: secondEntryNum,
            entrySize: entrySize
        )
    }

    func entryPoint(at index: Int) -> CGPoint {
        let entryNum = (drawHalf == .first) ? firstEntryNum : secondEntryNum
        let offset = (style.isHalf || drawHalf == .first) ? 0 : firstEntryNum

        switch style {
        case .left,
             .leftRight where drawHalf == .first:
            return (entryNum == 1)
                ? .init(x: 0, y: rect.midY)
                : .init(x: 0, y: drawMargin + stepSize.height * CGFloat(index))
        case .top,
             .topBottom where drawHalf == .first:
            return (entryNum == 1)
                ? .init(x: rect.midX, y: 0)
                : .init(x: drawMargin + stepSize.width * CGFloat(index), y: 0)
        case .right, .leftRight:
            return (entryNum == 1)
                ? .init(x: rect.width, y: rect.midY)
                : .init(x: rect.width, y: drawMargin + stepSize.height * CGFloat(index - offset))
        case .bottom, .topBottom:
            return (entryNum == 1)
                ? .init(x: rect.midX, y: rect.height)
                : .init(x: drawMargin + stepSize.width * CGFloat(index - offset), y: rect.height)
        }
    }
}
