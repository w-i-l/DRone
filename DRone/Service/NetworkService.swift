//
//  NetworkService.swift
//  DRone
//
//  Created by Mihai Ocnaru on 28.08.2023.
//

import Foundation
import Network
import Combine

final class NetworkService: ObservableObject {
    
    static let shared: NetworkService = .init()
    
    private(set) var isConnected: CurrentValueSubject<Bool, Never> = .init(false)
    @Published private(set) var isCellular: CurrentValueSubject<Bool, Never> = .init(false)
    
    private let nwMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue.global()
    
    private init() {
        start()
    }
    
    public func start() {
        nwMonitor.start(queue: workerQueue)
        nwMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected.value = path.status == .satisfied
                self?.isCellular.value = path.usesInterfaceType(.cellular)
            }
        }
    }
    
    public func stop() {
        nwMonitor.cancel()
    }
}
