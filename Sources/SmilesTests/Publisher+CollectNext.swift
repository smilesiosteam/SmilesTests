//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/12/2023.
//

import Foundation
import Combine

extension Publisher {
   public func collectNext(_ count: Int) -> AnyPublisher<[Output], Failure> {
        self.dropFirst()
            .collect(count)
            .first()
            .eraseToAnyPublisher()
    }
}
