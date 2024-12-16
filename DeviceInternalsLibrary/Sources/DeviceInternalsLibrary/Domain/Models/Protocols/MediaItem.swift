//
//  MediaItem.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// A protocol representing a media item with additional metadata.
protocol MediaItem: Item {
    var dateCreated: Date { get set }
    var byteFileSize: Int64 { get set }
}
