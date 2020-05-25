//
//  Container.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

protocol Containing {
    associatedtype T
    func register(_ element: T)
    func resolve<T>(_ typeToResolve: T.Type) -> T?
}

class Container<T> {
    private var elements = [T]()
}

extension Container: Containing {
    func register(_ element: T) {
        elements.append(element)
    }
    
    func resolve<T>(_ typeToResolve: T.Type) -> T? {
        let result = elements.first {
            guard let element = $0 as? T else {
                return false
            }
            return type(of: element) == typeToResolve
        }
        
        return result as? T
    }
}
