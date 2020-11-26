//
//  searchResponse.swift
//  Gifer
//
//  Created by miad yazeed on 24/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

// MARK: - AutoCompleteResponse
struct SearchResponse: Codable {
    let results: [String]
}
