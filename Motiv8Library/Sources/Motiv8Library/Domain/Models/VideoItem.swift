//
//  VideoItem.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// A model representing a video with metadata such as duration and file size.
public struct VideoItem: MediaItem {
    public var id: String
    public var title: String
    
    public var dateCreated: Date
    public var byteFileSize: Int64
    
    public var duration: Double
    
    init(id: String, title: String, dateCreated: Date, byteFileSize: Int64, duration: Double) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.byteFileSize = byteFileSize
        self.duration = duration
    }
    
    public init() {
        self.id = ""
        self.title = ""
        self.dateCreated = Date.distantPast
        self.byteFileSize = 0
        self.duration = 0
    }
}
