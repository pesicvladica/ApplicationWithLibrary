//
//  VideoFetcher.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// Use case for fetching video items.
final class VideoFetcher: UseCase {

    func execute(_ onCompletion: @escaping (Result<[VideoItem], Error>) -> Void) {
        repository.fetchListData(ofType: VideoItem.self, offset: 0, limit: 100, onCompletion)
    }
}
