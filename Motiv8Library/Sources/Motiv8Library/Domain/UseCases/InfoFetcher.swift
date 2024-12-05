//
//  InfoFetcher.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// Use case for fetching device information.
final class InfoFetcher: UseCase {

    func execute(_ onCompletion: @escaping (Result<DeviceItem, Error>) -> Void) {
        repository.fetchItemData(ofType: DeviceItem.self, onCompletion)
    }
}
