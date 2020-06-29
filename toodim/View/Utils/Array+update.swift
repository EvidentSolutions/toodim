//
//  Array+extensions.swift
//  toodim
//
//  Created by Henrik Huttunen on 13.6.2020.
//  Copyright © 2020 Henrik Huttunen. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    @discardableResult
    mutating func update(matching: Element, _ closure: (_ element: inout Element) -> ()) -> Bool {
        if let index = self.firstIndex(of: matching) {
            var element = self[index]
            closure(&element)
            self[index] = element
            return true
        } else {
            return false
        }
    }
    
    mutating func updateAll(_ closure: (_ element: inout Element) -> ()) -> () {
        self.indices.forEach { index in
            var element = self[index]
            closure(&element)
            self[index] = element
        }
    }
    
    /*
        Set value to true for given element, and others to false.
     */
    mutating func chooseElement(keyPath: WritableKeyPath<Element, Bool>, element: Element?) {
        self.updateAll { $0[keyPath: keyPath] = false }
        
        if let value = element {
            self.update(matching: value) {
                $0[keyPath: keyPath] = true
            }
        }
    }

}
