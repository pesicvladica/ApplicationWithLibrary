import Foundation

/// A centralized library providing access to various fetchers for device data, such as device information, contacts, images, and videos.
///
/// `Motiv8Library` serves as an entry point for interacting with the data-fetching capabilities of the application.
/// It utilizes a repository to manage and retrieve data from different stores.
/// - Note: By default, it uses a real data repository for fetching information.
///
/// # Fetchers:
/// - `infoFetcher`: Retrieves device-specific information.
/// - `contactFetcher`: Accesses the user's contacts.
/// - `imageFetcher`: Handles fetching metadata for device images.
/// - `videoFetcher`: Handles fetching metadata for device videos.
///
/// # Example Usage:
/// ```swift
/// let library = Motiv8Library()
/// library.contactFetcher.fetchNextPage { result in
///     switch result {
///     case .success(let contacts):
///         print("Fetched contacts: \(contacts)")
///     case .failure(let error):
///         print("Error fetching contacts: \(error)")
///     }
/// }
/// ```
public class Motiv8Library {
    
    // MARK: Private properties
    
    /// Repository used for fetching and managing data from various stores.
    private let registry: StoreRegistry
        
    // MARK: Public properties
    
    /// Fetcher for retrieving device-specific information.
    /// - SeeAlso: `InfoFetcher`.
    /// - Usage:
    /// ```swift
    /// library.infoFetcher.collect { result in ... }
    /// ```
    public lazy var infoFetcher: Fetcher<DeviceItem> = {
        let fetcher = Fetcher<DeviceItem>(registry: registry, storeType: .deviceInfo)
        return fetcher
    }()
    
    /// Fetcher for retrieving device contacts.
    /// - SeeAlso: `ContactFetcher`.
    /// - Usage:
    /// ```swift
    /// library.contactFetcher.getNextPage { result in ... }
    /// ```
    public lazy var contactFetcher: Fetcher<ContactItem> = {
        let fetcher = Fetcher<ContactItem>(registry: registry, storeType: .contact)
        return fetcher
    }()
    
    /// Fetcher for retrieving metadata about device images.
    /// - SeeAlso: `ImageFetcher`.
    /// - Usage:
    /// ```swift
    /// library.imageFetcher.prefetchAllItems { result in ... }
    /// ```
    public lazy var imageFetcher: Fetcher<ImageItem> = {
        let fetcher = Fetcher<ImageItem>(registry: registry, storeType: .image)
        return fetcher
    }()
    
    /// Fetcher for retrieving metadata about device videos.
    /// - SeeAlso: `VideoFetcher`.
    /// - Usage:
    /// ```swift
    /// library.videoFetcher.getNextPage { result in ... }
    /// ```
    public lazy var videoFetcher: Fetcher<VideoItem> = {
        let fetcher = Fetcher<VideoItem>(registry: registry, storeType: .video)
        return fetcher
    }()
    
    // MARK: Initialization
    
    /// Initializes the `Motiv8Library` with a custom or default repository.
    /// - Parameter repository: The repository instance to be used. If not provided, the default real data repository is used.
    /// - Example:
    /// ```swift
    /// let customRepo = MockFetchingRepository(...)
    /// let library = Motiv8Library(repository: customRepo)
    /// ```
    public init(registry: StoreRegistry) {
        self.registry = registry
    }
    
    // Factory method to allow for easy creation of the default registry
    public static func createDefaultLibrary() -> Motiv8Library {
        let storeFactory = MainStoreFactory()
        let registry = CentralRegistry(storeFactory: storeFactory)
        registry.registerStores(StoreType.allCases)
        return Motiv8Library(registry: registry)
    }
    
    // Factory method to allow for easy creation of the limited registry
    public static func createLibraryWith(stores: [StoreType]) -> Motiv8Library {
        let storeFactory = MainStoreFactory()
        let registry = CentralRegistry(storeFactory: storeFactory)
        registry.registerStores(stores)
        return Motiv8Library(registry: registry)
    }
}
