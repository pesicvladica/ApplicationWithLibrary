//
//  AnaliticsViewModel.swift
//  DeviceInternalsTestApp
//
//  Created by Vladica Pesic on 12/6/24.
//

import Foundation
import DeviceInternalsLibrary

class AnaliticsViewModel {
    
    // MARK: Private properties
    
    private let diLibrary: DeviceInternalsLibrary
    private let maxEntries = 15
    
    // MARK: Public properties
    
    var onResultsFetched: ((String?, Error?) -> Void)?
    
    // MARK: Initialization
    
    init(diLibrary: DeviceInternalsLibrary) {
        self.diLibrary = diLibrary
    }
    
    // MARK: Private methods
    
    private func analizeContactList(contacts: [ContactItem]) -> String {
        var result = ""
        
        var contactsNumberCount: [String: Int] = [:]
        // Loop through each contact and extract number of phone numbers
        for contact in contacts {
            let contactsNumberCountKey = "\(contact.phoneNumbers.count)"
            // Count the occurrences of each phone number count
            contactsNumberCount[contactsNumberCountKey, default: 0] += 1
        }
        let sorted = contactsNumberCount.sorted { value1, value2 in
            value1.key < value2.key
        }
        
        // Collect the distribution of phone numbers count
        for (index, (phoneNumberCount, count)) in sorted.enumerated() {
            if index == maxEntries { break }
            result += "\(phoneNumberCount) phone numbers: \(count) contacts\n"
        }
        
        return result
    }
    
    private func analizeImageList(images: [ImageItem]) -> String {
        var result = ""
        
        var resolutionCounts: [String: Int] = [:]
        // Loop through each image and extract its resolution
        for image in images {
            let resolutionKey = "\(image.dimension.width)x\(image.dimension.height)"
            // Count the occurrences of each resolution
            resolutionCounts[resolutionKey, default: 0] += 1
        }
        let sorted = resolutionCounts.sorted { value1, value2 in
            value1.value > value2.value
        }
        
        // Collect the distribution of resolutions
        for (index, (resolution, count)) in sorted.enumerated() {
            if index == maxEntries { break }
            result += "Resolution \(resolution): \(count) images\n"
        }
        
        return result
    }
    
    private func analizeVideosList(videos: [VideoItem]) -> String {
        var result = ""
        
        var durationsCount: [Int: Int] = [:]
        for video in videos {
            // Count the occurrences of each video duration
            durationsCount[Int(video.duration), default: 0] += 1
        }
        let sorted = durationsCount.sorted { value1, value2 in
            value1.value > value2.value
        }
        
        // Collect the distribution of video durations
        for (index, (duration, count)) in sorted.enumerated() {
            if index == maxEntries { break }
            result += "Duration \(duration) s: \(count) videos\n"
        }
        
        return result
    }
    
    // MARK: Public methods
    
    func calculateForContacts() {
        self.diLibrary.contactFetcher.getItems { [weak self] result in
            switch result {
            case .success(let fetchedContacts):
                let data = self?.analizeContactList(contacts: fetchedContacts)
                self?.onResultsFetched?(data, nil)
            case .failure(let error):
                self?.onResultsFetched?(nil, error)
            }
        }
    }
    
    func calculateForImages() {
        self.diLibrary.imageFetcher.getItems { [weak self] result in
            switch result {
            case .success(let fetchedimages):
                let data = self?.analizeImageList(images: fetchedimages)
                self?.onResultsFetched?(data, nil)
            case .failure(let error):
                self?.onResultsFetched?(nil, error)
            }
        }
    }
    
    func calculateForVideos() {
        self.diLibrary.videoFetcher.getItems { [weak self] result in
            switch result {
            case .success(let fetchedVideos):
                let data = self?.analizeVideosList(videos: fetchedVideos)
                self?.onResultsFetched?(data, nil)
            case .failure(let error):
                self?.onResultsFetched?(nil, error)
            }
        }
    }
}
