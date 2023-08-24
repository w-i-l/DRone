//
//  RsponseModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 21.08.2023.
//

import Foundation

enum ResponseResult: String, CaseIterable {
    case rejected = "Rejected"
    case accepted = "Accepted"
    case pending = "Pending"
    
    static func match(response: String) -> ResponseResult {
        
        for responseCase in ResponseResult.allCases {
            if response == responseCase.rawValue.lowercased() {
                return responseCase
            }
        }
        
        return .pending
    }
}

struct ResponseModel {
    var response: ResponseResult
    var ID: String
    var reason: String
}
