//
//  KRTournamentViewStyle.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

/// Direction of KRTournamentView.
///
/// - left: Entries are placed on the left.
/// - right: Entries are placed on the right.
/// - top: Entries are placed on the top.
/// - bottom: Entries are placed on the bottom.
/// - leftRight: Entries are placed on the left and right.
/// - topBottom: Entries are placed on the top and bottom.
public enum KRTournamentViewStyle {
    /// Direction of line of final match's winner on both side styles (.leftRight, .topBottom).
    public enum FinalDirection: Equatable { case top, bottom, left, right }

    case left, right, top, bottom
    case leftRight(direction: FinalDirection), topBottom(direction: FinalDirection)

    /// Alias for .leftRight(direction: .top)
    public static let leftRight = KRTournamentViewStyle.leftRight(direction: .top)

    /// Alias for .topBottom(direction: .right)
    public static let topBottom = KRTournamentViewStyle.topBottom(direction: .right)
}

// MARK: - Equatable ------------

extension KRTournamentViewStyle: Equatable {
    public static func == (lhs: KRTournamentViewStyle, rhs: KRTournamentViewStyle) -> Bool {
        switch (lhs, rhs) {
        case (.left, .left), (.right, .right), (.top, .top), (.bottom, .bottom):
            return true
        case (.leftRight(let lDirection), .leftRight(let rDirection)), (.topBottom(let lDirection), .topBottom(let rDirection)):
            return lDirection == rDirection
        default: return false
        }
    }
}

// MARK: - Internal computed property ------------

extension KRTournamentViewStyle {
    var direction: FinalDirection {
        switch self {
        case .left:     return .right
        case .right:    return .left
        case .top:      return .bottom
        case .bottom:   return .top
        case .leftRight(let direction):
            return (direction == .bottom) ? .bottom : .top
        case .topBottom(let direction):
            return (direction == .left) ? .left : .right
        }
    }

    var isVertical: Bool {
        switch self {
        case .left, .right, .leftRight: return true
        case .top, .bottom, .topBottom: return false
        }
    }

    var isHalf: Bool {
        switch self {
        case .left, .right, .top, .bottom:  return true
        case .leftRight, .topBottom:        return false
        }
    }
}

// MARK: - Internal action ------------

extension KRTournamentViewStyle {
    mutating func rotateLeft() {
        switch self {
        case .left:     self = .bottom
        case .right:    self = .top
        case .top:      self = .left
        case .bottom:   self = .right

        case .leftRight(let direction) where direction == .bottom:
            self = .topBottom(direction: .right)

        case .leftRight:
            self = .topBottom(direction: .left)

        case .topBottom(let direction) where direction == .left:
            self = .leftRight(direction: .bottom)

        case .topBottom:
            self = .leftRight(direction: .top)
        }
    }

    mutating func rotateRight() {
        switch self {
        case .left:     self = .top
        case .right:    self = .bottom
        case .top:      self = .right
        case .bottom:   self = .left

        case .leftRight(let direction) where direction == .bottom:
            self = .topBottom(direction: .left)

        case .leftRight:
            self = .topBottom(direction: .right)

        case .topBottom(let direction) where direction == .left:
            self = .leftRight(direction: .top)

        case .topBottom:
            self = .leftRight(direction: .bottom)
        }
    }

    mutating func reverse() {
        switch self {
        case .left:     self = .right
        case .right:    self = .left
        case .top:      self = .bottom
        case .bottom:   self = .top

        case .leftRight(let direction) where direction == .bottom:
            self = .leftRight(direction: .top)

        case .leftRight:
            self = .leftRight(direction: .bottom)

        case .topBottom(let direction) where direction == .left:
            self = .topBottom(direction: .right)

        case .topBottom:
            self = .topBottom(direction: .left)
        }
    }
}
