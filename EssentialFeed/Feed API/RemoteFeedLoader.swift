//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Andres Sanchez on 03/01/2025.
//
import Foundation

public protocol HTTPClient{
    //this function expect a url and a closure
    //A closure is a self-contained block of code
    func get(from url :URL, completionGet: @escaping (Error?, HTTPURLResponse?)->Void)
}

public final class RemoteFeedLoader{
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error{
        case connectivity
        case invalidData
    }
    public init(url: URL, client: HTTPClient){
        self.client = client
        self.url = url
    }
    public func load(completionLoad: @escaping (Error) -> Void ){
        /*
        client.get(from:url){ error in
            completion(.connectivity)
        }
        */
        client.get(from: url, completionGet: {error, response in
            print("load")
            //not passing down the error
            //here maps http error to domain error
            if response != nil {
                completionLoad(.invalidData)
            }else{
                completionLoad(.connectivity)
            }
        })
    }
}
