//
//  RsponseModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 21.08.2023.
//

import Foundation

enum ResponseResult: String {
    case rejected = "Rejected"
    case accepted = "Accepted"
    case pending = "Pending"
}

struct ResponseModel {
    var response: ResponseResult
    var ID: String
    var reason: String
}
