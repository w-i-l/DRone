//
//  ResponseService.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import Foundation
import Combine

class ResponseService {
    static let shared = ResponseService()
    
    private init() {}
    
    func getResponse(formModel: RequestFormModel) -> AnyPublisher<ResponseResult, Error> {
        return ResponseAPI.shared.getResponse(formModel: formModel)
            .eraseToAnyPublisher()
    }
}
