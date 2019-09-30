//
//  ServiceError.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 9/28/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Foundation

public enum ServiceError: Error {
    case badResponse
    case badUrl
    case generic
}
