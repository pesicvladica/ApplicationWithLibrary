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
    private let repository: FetchingRepository
    
    /// A default repository instance that provides real data sources for different item types.
    /// - Includes:
    ///   - `DeviceItem`: Fetched from `DeviceInfoStore`.
    ///   - `ContactItem`: Fetched from `DeviceContactStore`.
    ///   - `ImageItem`: Fetched from `DeviceGalleryStore` for `.image` type.
    ///   - `VideoItem`: Fetched from `DeviceGalleryStore` for `.video` type.
    private static let defaultRepository: CentralRepository = {
        let repository = CentralRepository()
        
        repository.registerStore(DeviceInfoStore())
        repository.registerStore(DeviceContactStore())
        repository.registerStore(DeviceGalleryStore(mediaType: .image))
        repository.registerStore(DeviceGalleryStore(mediaType: .video))
        
        return repository
    }()
    
    // MARK: Public properties
    
    /// Fetcher for retrieving device-specific information.
    /// - SeeAlso: `InfoFetcher`.
    /// - Usage:
    /// ```swift
    /// library.infoFetcher.collect { result in ... }
    /// ```
    public lazy var infoFetcher: InfoFetcher = {
        let fetcher = InfoFetcher(repository: repository)
        return fetcher
    }()
    
    /// Fetcher for retrieving device contacts.
    /// - SeeAlso: `ContactFetcher`.
    /// - Usage:
    /// ```swift
    /// library.contactFetcher.getNextPage { result in ... }
    /// ```
    public lazy var contactFetcher: ContactFetcher = {
        let fetcher = ContactFetcher(repository: repository)
        return fetcher
    }()
    
    /// Fetcher for retrieving metadata about device images.
    /// - SeeAlso: `ImageFetcher`.
    /// - Usage:
    /// ```swift
    /// library.imageFetcher.prefetchAllItems { result in ... }
    /// ```
    public lazy var imageFetcher: ImageFetcher = {
        let fetcher = ImageFetcher(repository: repository)
        return fetcher
    }()
    
    /// Fetcher for retrieving metadata about device videos.
    /// - SeeAlso: `VideoFetcher`.
    /// - Usage:
    /// ```swift
    /// library.videoFetcher.getNextPage { result in ... }
    /// ```
    public lazy var videoFetcher: VideoFetcher = {
        let fetcher = VideoFetcher(repository: repository)
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
    public init(repository: FetchingRepository? = nil) {
        if let repo = repository {
            self.repository = repo
        }
        else {
            self.repository = Motiv8Library.defaultRepository
        }
    }
}
