//
//  Observable.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import Foundation

final class Observable<T> {
    var closure: ((T) -> Void)?
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure : @escaping (T) -> Void){
        self.closure = closure
        closure(value)
    }
}
