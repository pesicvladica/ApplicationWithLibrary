//
//  ContactFetcher.swift
//
//
//  Created by Vladica Pesic on 12/4/24.
//

import Foundation

/// Use case for fetching contact items.
final class ContactFetcher: UseCase {

    func execute(_ onCompletion: @escaping (Result<[ContactItem], Error>) -> Void) {
        repository.fetchListData(ofType: ContactItem.self, offset: 0, limit: 100, onCompletion)
    }
}
