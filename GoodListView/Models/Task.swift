//
//  Task.swift
//  GoodListView
//
//  Created by DGSA/iOS on 06/12/22.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
