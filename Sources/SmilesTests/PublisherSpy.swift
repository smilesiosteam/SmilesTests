//
//  File.swift
//
//
//  Created by Ahmed Naguib on 14/12/2023.
//

import Foundation
import Combine

final public class PublisherSpy<T> {
    private(set) var value: T!
    private var cancellable: Cancellable?
    public init(_ publisher: any Publisher<T, Never>) {
        cancellable = publisher.sink { [weak self] value in
            self?.value = value
        }
    }
}
