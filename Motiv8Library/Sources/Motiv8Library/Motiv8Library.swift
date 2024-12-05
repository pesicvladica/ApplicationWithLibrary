import Foundation

open class Motiv8Library {
    
    // MARK: Private properties
    
    /// Repository used for fetching and managing data from various stores.
    private let repository: GenericFetchingRepository
    
    // MARK: Public properties
    
    /// Lazy-initialized fetcher for device information.
    public lazy var infoFetcher: InfoFetcher = {
        let fetcher = InfoFetcher(repository: repository)
        return fetcher
    }()
    
    /// Lazy-initialized fetcher for device contacts.
    public lazy var contactFetcher: ContactFetcher = {
        let fetcher = ContactFetcher(repository: repository)
        return fetcher
    }()
    
    /// Lazy-initialized fetcher for device images.
    public lazy var imageFetcher: ImageFetcher = {
        let fetcher = ImageFetcher(repository: repository)
        return fetcher
    }()
    
    /// Lazy-initialized fetcher for device videos.
    public lazy var videoFetcher: VideoFetcher = {
        let fetcher = VideoFetcher(repository: repository)
        return fetcher
    }()
    
    // MARK: Initialization
    
    /// Shared singleton instance of `Motiv8Library`.
    public static let instance: Motiv8Library = Motiv8Library()
    
    /// Private initializer to enforce singleton pattern.
    private init() {
        repository = GenericFetchingRepository(stores: [
            String(describing: DeviceItem.self) : DeviceInfoStore(),
            String(describing: ContactItem.self) : DeviceContactStore(),
            String(describing: ImageItem.self) : DeviceGalleryStore<ImageItem>(mediaType: .image),
            String(describing: VideoItem.self) : DeviceGalleryStore<VideoItem>(mediaType: .video)
        ])
    }
    
    // MARK: Public methods
    
    /// Fetches device information using the `InfoFetcher`.
    ///
    /// - Parameter onCompletion: A completion handler that provides the result of the fetch operation.
    ///   - If successful, the result contains a `DeviceItem`.
    ///   - If unsuccessful, the result contains an `Error`.
    public func fetchDeviceInfo(_ onCompletion: @escaping (Result<DeviceItem, Error>) -> Void) {
        infoFetcher.collectInfo(onCompletion)
    }
    
    /// Fetches the next page of contacts using the `ContactFetcher`.
    ///
    /// - Parameter onCompletion: A completion handler that provides the result of the fetch operation.
    ///   - If successful, the result contains an array of `ContactItem` objects.
    ///   - If unsuccessful, the result contains an `Error`.
    public func fetchNextContactsPage(_ onCompletion: @escaping (Result<[ContactItem], Error>) -> Void) {
        contactFetcher.getNextPage(onCompletion)
    }
    
    /// Resets the internal state of the `ContactFetcher`, including the pagination offset and cached contacts.
    ///
    /// Use this method to restart fetching contacts from the beginning.
    public func resetContactsState() {
        contactFetcher.reset()
    }
    
    /// Fetches the next page of images using the `ImageFetcher`.
    ///
    /// - Parameter onCompletion: A completion handler that provides the result of the fetch operation.
    ///   - If successful, the result contains an array of `ImageItem` objects.
    ///   - If unsuccessful, the result contains an `Error`.
    public func fetchNextImagesPage(_ onCompletion: @escaping (Result<[ImageItem], Error>) -> Void) {
        imageFetcher.getNextPage(onCompletion)
    }
    
    /// Resets the internal state of the `ImageFetcher`, including the pagination offset and cached images.
    ///
    /// Use this method to restart fetching images from the beginning.
    public func resetImagesState() {
        imageFetcher.reset()
    }
    
    /// Fetches the next page of videos using the `VideoFetcher`.
    ///
    /// - Parameter onCompletion: A completion handler that provides the result of the fetch operation.
    ///   - If successful, the result contains an array of `VideoItem` objects.
    ///   - If unsuccessful, the result contains an `Error`.
    public func fetchNextVideosPage(_ onCompletion: @escaping (Result<[VideoItem], Error>) -> Void) {
        videoFetcher.getNextPage(onCompletion)
    }
    
    /// Resets the internal state of the `VideoFetcher`, including the pagination offset and cached videos.
    ///
    /// Use this method to restart fetching videos from the beginning.
    public func resetVideosState() {
        videoFetcher.reset()
    }
}


