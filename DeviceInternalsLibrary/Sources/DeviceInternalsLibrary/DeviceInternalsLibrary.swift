import Foundation

/// A comprehensive library providing access to device data through configurable fetchers.
///
/// The `DeviceInternalsLibrary` serves as a high-level interface for retrieving device-related data, such as device
/// information, contacts, images, and videos. It utilizes a `StoreRegistry` to manage and interact with
/// underlying data stores, providing an abstraction layer for efficient data access.
///
/// The library includes preconfigured fetchers for different types of data, and it can be customized to
/// include only the necessary stores for specific use cases.
public class DeviceInternalsLibrary {
    
    // MARK: Private properties
    
    /// The registry managing the underlying stores for data fetching.
    private let registry: StoreRegistry
        
    // MARK: Public properties
    
    /// Fetcher for retrieving detailed information about the device.
    public lazy var infoFetcher: Fetcher<DeviceItem> = {
        Fetcher<DeviceItem>(registry: registry, storeType: InternalType.deviceInfo)
    }()
    
    /// Fetcher for accessing contacts stored on the device.
    public lazy var contactFetcher: Fetcher<ContactItem> = {
        Fetcher<ContactItem>(registry: registry, storeType: InternalType.contact)
    }()
    
    /// Fetcher for retrieving image assets from the device's photo gallery.
    public lazy var imageFetcher: Fetcher<ImageItem> = {
        Fetcher<ImageItem>(registry: registry, storeType: InternalType.image)
    }()
    
    /// Fetcher for retrieving video assets from the device's photo gallery.
    public lazy var videoFetcher: Fetcher<VideoItem> = {
        Fetcher<VideoItem>(registry: registry, storeType: InternalType.video)
    }()
    
    // MARK: Initialization
    
    /// Initializes the library with a provided `StoreRegistry`.
    ///
    /// - Parameters:
    ///   - registry: The registry used to manage and interact with data stores.
    ///
    /// This allows for dynamic interaction with registered stores and fetchers.
    init(registry: StoreRegistry) {
        self.registry = registry
    }
    
    /// Creates a default library instance with all supported data stores preconfigured.
    ///
    /// This method initializes a `DeviceInternalsLibrary` instance with the following fetchers:
    /// - Device information fetcher
    /// - Contact fetcher
    /// - Image fetcher
    /// - Video fetcher
    ///
    /// - Returns:
    ///   - A fully configured `DeviceInternalsLibrary` instance.
    public static func createDefaultLibrary() -> DeviceInternalsLibrary {
        let storeFactory = MainStoreFactory()
        let registry = CentralRegistry(storeFactory: storeFactory)
        do {
            try registry.registerStores(InternalType.allCases)
        }
        catch {
            preconditionFailure("In this scenario registering stores can not fail \(error)")
        }
        return DeviceInternalsLibrary(registry: registry)
    }
    
    /// Creates a library instance with a custom subset of supported data stores.
    ///
    /// - Parameters:
    ///   - stores: An array of `InternalType` values specifying the stores to be registered.
    /// This allows clients to optimize the library for specific use cases, such as only fetching
    /// images or contacts.
    ///
    /// - Returns:
    ///   - A `DeviceInternalsLibrary` instance configured with the specified stores.
    public static func createLibraryWith(stores: [InternalType]) -> DeviceInternalsLibrary {
        let storeFactory = MainStoreFactory()
        let registry = CentralRegistry(storeFactory: storeFactory)
        do {
            try registry.registerStores(stores)
        }
        catch {
            preconditionFailure("In this scenario registering stores can not fail \(error)")
        }
        return DeviceInternalsLibrary(registry: registry)
    }
}
