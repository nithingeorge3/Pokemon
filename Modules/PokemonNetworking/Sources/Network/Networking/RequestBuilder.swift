//
//  RequestBuilder.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
//

import Foundation

protocol RequestBuilderType: Sendable {
    func buildRequest(url: URL, apiKey: String?) -> URLRequest
}

final class RequestBuilder: RequestBuilderType {
    func buildRequest(url: URL, apiKey: String? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.addValue("tasty.p.rapidapi.com",
                         forHTTPHeaderField: "x-rapidapi-host")
        if let apiKey = apiKey {
            request.addValue(apiKey,
                             forHTTPHeaderField: "x-rapidapi-key")
        }
        print("****request: \(request)")
        return request
    }
}

