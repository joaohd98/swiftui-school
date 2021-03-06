//
//  ConcurrentSequence.swift
//  Sims School
//
//  Created by João Damazio on 30/07/20.
//  Copyright © 2020 João Damazio. All rights reserved.
//

import Foundation
import Dispatch

class SharedSynchronizedArray<T> {
    var array = [T]()
    let operationQueue = DispatchQueue(label: "SharedSynchronizedArray")

    func append(_ newElement: T) {
        operationQueue.sync {
            array.append(newElement)
        }
    }
}

struct ConcurrentSequence<Base, Element>: Sequence
    where Base: Sequence, Element == Base.Iterator.Element {
    let base: Base

    public func makeIterator() -> Base.Iterator {
        return base.makeIterator()
    }

    public func map<T>(_ transform: @escaping (Element) -> T) -> [T] {
        let group = DispatchGroup()

        let resultsStorageQueue = DispatchQueue(label: "resultStorageQueue")
        let results = SharedSynchronizedArray<T>()

        let processingQueue = DispatchQueue(
            label: "processingQueue",
            attributes: [.concurrent]
        )

        for element in self {
            group.enter()
            print("Entered DispatchGroup for \(element)")

            var result: T?
            let workItem = DispatchWorkItem{ result = transform(element) }

            processingQueue.async(execute: workItem)

            resultsStorageQueue.async {
                workItem.wait()
                guard let unwrappedResult = result else {
                    fatalError("The work item was completed, but the result wasn't set!")
                }
                results.append(unwrappedResult)


                group.leave()
                print("Exited DispatchGroup for \(element)")
            }
        }
        print("Started Waiting on DispatchGroup")
        group.wait()
        print("DispatchGroup done")

        return results.array
    }


}

extension Sequence {
	var parallel: ConcurrentSequence<Self, Iterator.Element> {
        return ConcurrentSequence(base: self)
    }
}
