//
//  Extension.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import Foundation

extension String? {
    var validatedURL: URL? {
        guard let self = self else { return nil }
        return URL(string: self)
    }
}
