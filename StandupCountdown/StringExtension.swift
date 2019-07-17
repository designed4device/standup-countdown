//
//  StringExtension.swift
//  StandupCountdown
//
//  Created by Mike Wellen on 7/16/19.
//  Copyright © 2019 Mike Wellen. All rights reserved.
//

import Foundation

extension String {
    func pad() -> String {
        if (self.count < 2) {
            return "0\(self)"
        }
        return self
    }
}
