//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/12/2023.
//

import Foundation

public func readJsonFile<T: Decodable>(_ fileName: String, bundle: Bundle)  -> T? {
    // Get the file URL
    guard let fileURL = bundle.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: fileURL) else {
        return nil
    }
    // Decode JSON data into the specified type
    let decoder = JSONDecoder()
    let decodedObject = try? decoder.decode(T.self, from: data)
    return decodedObject
}
