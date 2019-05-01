//
//  KRTournamentCalculatable.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit

enum DrawHalf { case first, second }

struct TournamentInfo {
    private let offset: Int
    private let firstEntryNum: Int
    private let secondEntryNum: Int

    let numberOfLayer: Int
    let style: KRTournamentViewStyle
    let drawHalf: DrawHalf
    let rect: CGRect

    let entrySize: CGSize
    let stepSize: CGSize
    let drawMargin: CGFloat

    init(structure: Bracket, style: KRTournamentViewStyle, drawHalf: DrawHalf, rect: CGRect, entrySize: CGSize) {
        self.init(
            offset: style.isHalf ? 0 : structure.entries(style: style, drawHalf: .first).count,
            numberOfLayer: structure.matchPath.layer,
            style: style,
            drawHalf: drawHalf,
            rect: rect,
            firstEntryNum: structure.entries(style: style, drawHalf: .first).count,
            secondEntryNum: structure.entries(style: style, drawHalf: .second).count,
            entrySize: entrySize
        )
    }

    private init(
        offset: Int,
        numberOfLayer: Int,
        style: KRTournamentViewStyle,
        drawHalf: DrawHalf,
        rect: CGRect,
        firstEntryNum: Int,
        secondEntryNum: Int,
        entrySize: CGSize
        ) {
        self.offset = offset
        self.numberOfLayer = numberOfLayer
        self.style = style
        self.drawHalf = drawHalf
        self.rect = rect
        self.firstEntryNum = firstEntryNum
        self.secondEntryNum = secondEntryNum

        let entryNum = (drawHalf == .first) ? firstEntryNum : secondEntryNum

        let entrySize: CGSize = {
            let length = style.isVertical ? entrySize.height : entrySize.width
            let frameLength = style.isVertical ? rect.height : rect.width
            let maxLength = frameLength / max(CGFloat(entryNum), 1)
            return style.isVertical ?
                .init(width: entrySize.width, height: min(length, maxLength)) :
                .init(width: min(length, maxLength), height: entrySize.height)
        }()
        self.entrySize = entrySize

        let drawMargin = style.isVertical ? entrySize.height / 2 : entrySize.width / 2
        self.drawMargin = drawMargin

        self.stepSize = {
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
    }

    func convert(drawHalf: DrawHalf) -> TournamentInfo {
        return .init(
            offset: offset,
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

        if entryNum == 1 {
            return style.isVertical ? .init(x: 0, y: rect.midY) : .init(x: rect.midX, y: 0)
        }

        switch style {
        case .left,
             .leftRight where drawHalf == .first:
            return .init(x: 0, y: drawMargin + stepSize.height * CGFloat(index))
        case .top,
             .topBottom where drawHalf == .first:
            return .init(x: drawMargin + stepSize.width * CGFloat(index), y: 0)
        case .right:
            return .init(x: rect.width, y: drawMargin + stepSize.height * CGFloat(index))
        case .bottom:
            return .init(x: drawMargin + stepSize.width * CGFloat(index), y: rect.height)
        case .leftRight:
            return .init(x: rect.width, y: drawMargin + stepSize.height * CGFloat(index - offset))
        case .topBottom:
            return .init(x: drawMargin + stepSize.width * CGFloat(index - offset), y: rect.height)
        }
    }
}
