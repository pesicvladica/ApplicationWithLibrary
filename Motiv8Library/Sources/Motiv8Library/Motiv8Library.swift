// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine
import Photos
import Contacts

open class Motiv8Library {
    
    private let repository: GenericFetchingRepository
    
    public static let instance: Motiv8Library = Motiv8Library()
    private init() {
        repository = GenericFetchingRepository(stores: [
            String(describing: DeviceItem.self) : DeviceInfoStore(),
            String(describing: ContactItem.self) : DeviceContactStore(),
            String(describing: ImageItem.self) : DeviceGalleryStore<ImageItem>(mediaType: .image),
            String(describing: VideoItem.self) : DeviceGalleryStore<VideoItem>(mediaType: .video)
        ])
    }
    
    public func fetchDeviceInfo(_ completion: @escaping (DeviceItem?) -> Void) {
        let useCase = InfoFetcher(repository: repository)
        useCase.execute { result in
            switch result {
            case .success(let deviceInfo):
                completion(deviceInfo)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    public func fetchContacts(completion: @escaping ([ContactItem]) -> Void) {
        let useCase = ContactFetcher(repository: repository)
        useCase.execute { result in
            switch result {
            case .success(let contacts):
                completion(contacts)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    public func fetchImages(_ completion: @escaping ([ImageItem]) -> Void) {
        let useCase = ImageFetcher(repository: repository)
        useCase.execute { result in
            switch result {
            case .success(let images):
                completion(images)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    public func fetchVideos(_ completion: @escaping ([VideoItem]) -> Void) {
        let useCase = VideoFetcher(repository: repository)
        useCase.execute { result in
            switch result {
            case .success(let videos):
                completion(videos)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}


