//
//  RequestBuilder.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
//

import Foundation

protocol RequestBuilderType: Sendable {
    func buildRequest(url: URL) -> URLRequest
}

final class RequestBuilder: RequestBuilderType {
    func buildRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        print("****request: \(request)")
        return request
    }
}

