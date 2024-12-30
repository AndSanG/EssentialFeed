//  RemoteFeedLoaderTests.swift
//  EssentialFeed
//  Created by Andres Sanchez on 29/12/2024.

import XCTest

class RemoteFeedLoader{
    let client: HTTPClient
    init(client: HTTPClient){
        self.client = client
    }
    func load(){
        // The client instance is injected through constructor
        client.get(from: URL(string: "https://a-url.com")!)
    }
}
//abstract class, change to protocol
protocol HTTPClient{
    func get(from url :URL)
}
class HTTPClientSpy: HTTPClient{
    func get(from url :URL){
        requestedURL = url
    }
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL(){
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client:client)
        //Assert that the request is only made when load is changed.
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}

