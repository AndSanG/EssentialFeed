//
//  SharedTestHelpers.swift
//  EssentialFeed
//
//  Created by Andres Sanchez on 27/12/25.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
