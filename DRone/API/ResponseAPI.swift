//
//  ResponseAPI.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import Combine
import Foundation
import SwiftyJSON

class ResponseAPI {
    
    static let shared = ResponseAPI()
    
    private init() {}
    
    func getResponse(formModel: RequestFormModel) -> Future<ResponseModel, Error> {
        Future<ResponseModel, Error> { promise in
            
            let urlComponents = URLComponents(string: "https://drone-ob9o.api.mocked.io/flight-request")
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            urlRequest.httpMethod = "POST"
            do {
                let encoded = try JSONEncoder().encode(formModel)
                urlRequest.httpBody = encoded
            } catch(let error) {
                promise(.failure(error))
            }
            
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                guard let data else { promise(.failure(NSError(domain: "Error data", code: 1))); return}
                guard error == nil else { promise(.failure(NSError(domain: "Error != nil", code: 2))); return}
                
                do {
                    let json = try JSON(data: data)
                    
                    let isAccepted = json["response"].stringValue == "accepted"
                    let ID = json["id"].stringValue
                    promise(.success(ResponseModel(
                        response: isAccepted ? .accepted : .rejected,
                        ID: ID,
                        reason: json["reason"].stringValue
                    )))
                    
                } catch(_) {
                    promise(.failure(NSError(domain: "Error data", code: 1)))
                    return
                }
            }
            
            dataTask.resume()
            
        }
    }
}
