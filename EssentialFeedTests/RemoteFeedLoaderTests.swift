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
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    // this test how many times was called
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url:url)
        sut.load()
        sut.load()
        XCTAssertEqual(client.requestedURLs,[url,url])
    }
    // When the client Fails we need to send an error.
    func test_load_deliversErrorOnClientError(){
        print("test_load_deliversErrorOnClientError")
        //get a sutRFL and a clientSpyTD
        // sutRFL is the object of the test
        // clientSpyTD is a Test Double that we need.
        //MARK: ARRANGE
        let (sutRFL,clientSpyTD) = makeSUT()
        // the Spy has a Stubbed error
        // Stubb is an object with predefined behavior used to control the behavior of dependencies during a test.
        // here is mixed spy capture with stub
        // stub before call load that is not async
        // spy just capture.
        clientSpyTD.errorSpy = NSError(domain: "Test", code: 0)
        //MARK: ACT
        // create a capturedError of FRL.error
        var capturedError = [RemoteFeedLoader.Error]()
        //this was preparation
        //when load is called delivers a connectivity error (DDD especifications)
        //sutRFL.load{error in capturedError = error}
        //longhand
        sutRFL.load(completionLoad:
                        {(error:RemoteFeedLoader.Error) -> Void in
                        print("captured error: ", error)
                            //this is executed in client get
                            //.conectivity is called in load
                            //.connectivity is the argument passed to this closure
                            //assignt the error that was called with completion in load
                            // now is only .connectivity
                            capturedError.append(error)
                        })
        
        print(capturedError)
        //MARK: ASSERT
        XCTAssertEqual(capturedError, [.connectivity])
    }
    //MARK: - Helpers
    // create an instance of sut (RemoteFeedLoader) and a client (HTTPClientSpy)
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sutRFL: RemoteFeedLoader, clientSpyTD: HTTPClientSpy) {
        let clientSpyTD = HTTPClientSpy()
        let sutRFL = RemoteFeedLoader(url: url, client: clientSpyTD)
        return (sutRFL, clientSpyTD)
    }
    
    // RemoteFeedLoader interacts with an HTTP client, RFL needs a test double
    // Test double is a pretend object used in place of a real object for testing purposes
    // The client is an Spy captures and makes available parameter and state information, publishing
    //     accessors to test code for private information allowing for more advanced state validation.
    // Captures the URL of the instance, we can have the production client and the test client.
    // Inject a client using Protocols instead of OOP
    private class HTTPClientSpy: HTTPClient {
        // this properties are the captured values of a spy
        var requestedURLs = [URL]()
        //set elsewhere at instantiation or later
        var errorSpy: Error?
        // add to an array to compare count order and value.
        // this is from the protocol
        func get(from url: URL, completionGet: (any Error) -> Void) {
            if let errorSpyUnwrapped = errorSpy {
                print("get")
                //call the completion with the error.
                completionGet(errorSpyUnwrapped)
            }
            //spy the url
            requestedURLs.append(url)
        }
    }
}

