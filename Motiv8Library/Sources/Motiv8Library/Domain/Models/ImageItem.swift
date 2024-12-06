//
//  ImageItem.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// A model representing an image with metadata such as dimensions and file size.
public struct ImageItem: MediaItem {
    public var id: String
    public var title: String
    
    public var dateCreated: Date
    public var byteFileSize: Int64
    
    public var dimension: CGSize
    
    init(id: String, title: String, dateCreated: Date, byteFileSize: Int64, dimension: CGSize) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.byteFileSize = byteFileSize
        self.dimension = dimension
    }
    
    public init() {
        self.id = ""
        self.title = ""
        self.dateCreated = Date.distantPast
        self.byteFileSize = 0
        self.dimension = .zero
    }
}
