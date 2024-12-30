//  RemoteFeedLoaderTests.swift
//  EssentialFeed
//  Created by Andres Sanchez on 29/12/2024.

import XCTest

class RemoteFeedLoader{
    func load(){
        //2 move test logic from RFL to HTTPClient
        HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)
    }
}

class HTTPClient{
    //1 shared instace is a var
    static var shared = HTTPClient()
    func get(from url :URL){}
}
//3 move test loginc to a different class
class HTTPClientSpy: HTTPClient{
    override func get(from url :URL){
        requestedURL = url
    }
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL(){
        //swap shared instance with spy subclass for testing
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        //Assert that the request is only made when load is changed.
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_requestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}

