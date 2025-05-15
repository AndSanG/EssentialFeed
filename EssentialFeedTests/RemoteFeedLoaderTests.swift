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
        sut.load(completionLoad: {_ in })
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    // this test how many times was called
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url:url)
        sut.load(completionLoad: {_ in })
        sut.load(completionLoad: {_ in })
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
        // no stubbed error here anymore
        
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
        //this was moved from arrange to act
        //when the client (get) complete with an error we want the load to complete with an error as well
        let clientError = NSError(domain: "Test", code: 0)
        //completion happens after invoking load
        //call the completion with the error.
        // the load called get but it was not executed just captured
        //just now goes back, before the call hierarchy just reached get and stored the closure.
        //here it is called, this changed the order. Before the loop was completed thats why the error needed to be stubbed.
        
        // HERE THE CLIENT ANSWER more realistic. That`s the reason the error is here.
        // This is executed after load but it can be more time simulating the http answer
        
        //move the array indexing to the Spy
        clientSpyTD.completeSpy(with: clientError)
        
        //MARK: ASSERT
        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse(){
        //MARK: ARRANGE
        let (sutRFL,clientSpyTD) = makeSUT()
        let samples = [199, 201, 300, 400, 500].enumerated()
        
        samples.forEach{index, code in
            //MARK: ACT
            var capturedError = [RemoteFeedLoader.Error]()
            sutRFL.load(completionLoad: {error in capturedError.append(error)})
            clientSpyTD.completeSpy(withStatusCode: code, at: index)
            //MARK: ASSERT
            XCTAssertEqual(capturedError, [.invalidData])
        }
        
        
        
        
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
        // move from stubbing to capture closures
        // dont have behaviour just acumulate properties
        // both urls and closures in only one array of tuples
        private var messages = [(url: URL, completionGet: (Error?, HTTPURLResponse?) -> Void )]()
        
        // calculated property: goes through the tuple`s array creating other array
        var requestedURLs: [URL]{
            return messages.map{$0.url}
        }
        
        // add to an array to compare count order and value.
        // this is from the protocol
        func get(from url: URL, completionGet: @escaping(Error?, HTTPURLResponse?) -> Void) {
            
            //spy (capture) the closure and url. IT IS NOT CALLED just captured.
            messages.append((url,completionGet))
            
        }
        // the called passed here to execute the closure later on demand instead of instantly
        // just convinient way to call the closure that was stored.
        func completeSpy(with error: Error, at index: Int = 0){
            messages[index].completionGet(error, nil)
        }
        
        func completeSpy(withStatusCode code : Int, at index: Int = 0 ){
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )
            messages[index].completionGet(nil, response)
        }
    }
}

