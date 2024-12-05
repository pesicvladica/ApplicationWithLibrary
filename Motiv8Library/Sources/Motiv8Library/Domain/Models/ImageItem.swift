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
}
