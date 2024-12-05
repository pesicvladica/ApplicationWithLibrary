//
//  ImageFetcher.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// Use case for fetching image items.
final class ImageFetcher: UseCase {

    func execute(_ onCompletion: @escaping (Result<[ImageItem], Error>) -> Void) {
        repository.fetchListData(ofType: ImageItem.self, offset: 0, limit: 100, onCompletion)
    }
}
