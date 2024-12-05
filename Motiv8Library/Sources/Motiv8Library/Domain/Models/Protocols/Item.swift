//
//  Item.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// A protocol representing an identifiable item with title.
protocol Item: Identifiable {
    var id: String { get set }
    var title: String { get set }
}
