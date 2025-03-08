//
//  Extension.swift
//  Recipes
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation

extension String? {
    var validatedURL: URL? {
        guard let self = self else { return nil }
        return URL(string: self)
    }
}
