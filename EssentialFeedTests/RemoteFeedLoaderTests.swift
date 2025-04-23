//  RemoteFeedLoaderTests.swift
//  EssentialFeed
//  Created by Andres Sanchez on 29/12/2024.

import XCTest
import EssentialFeed
class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL(){
        let (_, client) = makeSUT()
        //Assert that the request is only made when load is changed.
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    // this test if it was called correctly
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url:url)
        sut.load{ _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    // this test how many times was called
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url:url)
        sut.load{ _ in }
        sut.load{ _ in }
        XCTAssertEqual(client.requestedURLs,[url,url])
        
    }
    
    func test_load_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load{capturedErrors.append($0)}
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url:URL, completion:(Error) -> Void)]()
        var requestedURLs: [URL]{
            return messages.map { $0.url }
        }
        // add to an array to compare count order and value.
        func get(from url: URL, completion: @escaping (Error)->Void) {
            messages.append((url,completion))
        }
        
        func complete(with error: Error, at index: Int = 0){
            messages[index].completion(error)
        }
    }
}

