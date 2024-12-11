//
//  StoreFactory.swift
//
//
//  Created by Vladica Pesic on 12/11/24.
//

import Foundation

protocol StoreFactory {
    func createStore(for type: StoreType) -> any Store
}
