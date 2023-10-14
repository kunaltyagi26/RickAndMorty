//
//  Service.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 14/10/23.
//

import Foundation

final class Service {
    static let shared = Service()
    
    private init() {}
    
    func execute(_ request: Request, completion: @escaping() -> Void) {
        
    }
}
