//
//  RecipeServiceParser.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
//

import Foundation
import Combine

protocol ServiceParserType: Sendable {
    func parse<T: Decodable>(data: Data, response: URLResponse, type: T.Type) async throws -> T
    func parse<T: Decodable>(data: Data, response: URLResponse, type: T.Type) -> AnyPublisher<T, Error>
}

final class ServiceParser: ServiceParserType {    
    func parse<T: Decodable>(data: Data, response: URLResponse, type: T.Type) async throws -> T {
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.responseError
        }
        
        do {
            let decoder = createDecoder()
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch let decodingError {
            print("RecipeParser - Decoding error: \(decodingError)")
            throw NetworkError.failedToDecode
        } 
    }
    
    func parse<T: Decodable>(data: Data, response: URLResponse, type: T.Type) -> AnyPublisher<T, Error> {
       Just((data, response))
           .tryMap { (data, response) -> Data in
               guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                   throw NetworkError.responseError
               }
               return data
           }
           .decode(type: T.self, decoder: createDecoder())
           .mapError { error -> Error in
               if let _ = error as? DecodingError {
                   return NetworkError.failedToDecode
               } else {
                   return NetworkError.unKnown
               }
           }
           .eraseToAnyPublisher()
   }
    
    private func createDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
