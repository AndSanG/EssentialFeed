//  RemoteFeedLoaderTests.swift
//  EssentialFeed
//  Created by Andres Sanchez on 29/12/2024.

import XCTest

class RemoteFeedLoader{
    let client: HTTPClient
    let url: URL
    init(url: URL, client: HTTPClient){
        self.client = client
        self.url = url
    }
    func load(){
        // The client instance is injected through constructor
        client.get(from:url)
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
        let url = URL(string: "https://a-url.com")!
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url:url, client:client)
        //Assert that the request is only made when load is changed.
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url:url!, client: client)
        sut.load()
        XCTAssertEqual(client.requestedURL, url)
    }
}

