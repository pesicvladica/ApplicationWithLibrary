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
    
    public init(id: String = "", title: String = "", dateCreated: Date = .distantPast, byteFileSize: Int64 = 0, duration: Double = 0) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.byteFileSize = byteFileSize
        self.duration = duration
    }
}
