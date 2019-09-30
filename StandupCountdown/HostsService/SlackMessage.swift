//
//  SlackMessage.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 9/30/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Foundation

struct SlackMessage: Encodable {
    let channel: String
    let message: String
}
