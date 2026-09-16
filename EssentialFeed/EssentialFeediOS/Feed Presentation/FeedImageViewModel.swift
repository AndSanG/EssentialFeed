//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Andres Sanchez on 8/9/26.
//

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        return location != nil
    }
}
