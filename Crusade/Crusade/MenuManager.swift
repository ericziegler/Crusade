//
//  MenuManager.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/22/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import Foundation

// MARK: - Enums

enum MenuItemType: String {
    case routes = "Routes"
    case registerVoter = "Register to Vote"
    case checkRegistration = "Check Registration"
    case absenteeBallot = "Absentee Ballot"
    case voteReminder = "Vote Reminders"
    case votePledge = "Pledge to Vote"

    var headerTitle: String {
        switch self {
        case .registerVoter:
            return "Registration"
        case .checkRegistration:
            return "Check Registration"
        case .absenteeBallot:
            return "Absentee Ballot"
        case .voteReminder:
            return "Vote Reminders"
        case .votePledge:
            return "Voter Pledge"
        default:
            return "Route"
        }
    }

    var fileName: String {
        switch self {
        case .registerVoter:
            return "register"
        case .checkRegistration:
            return "checkregistration"
        case .absenteeBallot:
            return "absentee"
        case .voteReminder:
            return "votereminder"
        case .votePledge:
            return "votepledge"
        default:
            return ""
        }
    }

}
