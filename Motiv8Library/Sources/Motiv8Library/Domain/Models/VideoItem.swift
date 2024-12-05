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
}
