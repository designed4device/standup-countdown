//
//  HostsResponse.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 9/28/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Foundation

struct Host: Decodable, Encodable {
    let name: String
    let id: String
}
