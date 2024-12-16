//
//  ImageItem.swift
//  
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation
import CoreGraphics

/// A model representing an image with metadata such as dimensions and file size.
public struct ImageItem: MediaItem {
    public var id: String
    public var title: String
    
    public var dateCreated: Date
    public var byteFileSize: Int64
    
    public var dimension: CGSize
    
    public init(id: String = "", title: String = "", dateCreated: Date = .distantPast, byteFileSize: Int64 = 0, dimension: CGSize = CGSize.zero) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.byteFileSize = byteFileSize
        self.dimension = dimension
    }
}
