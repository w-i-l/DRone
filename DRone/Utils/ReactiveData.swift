//
//  ReactiveData.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import Combine
import Foundation

public enum DataState<T> {
    case loading
    case ready(T)
    case failure(Error)
    
    public var value: T? {
        if case let .ready(t) = self {
            return t
        }
        return nil
    }
    
    public var isReady: Bool {
        if case .ready(_) = self {
            return true
        }
        return false
    }
    
    public var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    public var isFailed: Bool {
        if case .failure(_) = self {
            return true
        }
        return false
    }
    
    public var error: Error? {
        if case let .failure(error) = self {
            return error
        }
        return nil
    }
}

public class ReactiveData<T> {
    
    private var cancellables = Set<AnyCancellable>()
    
    private var publisherClosure: () -> (AnyPublisher<T, Error>?)
    private var inFlightPublisher: AnyPublisher<T, Error>?
    private var stateSubject = CurrentValueSubject<DataState<T>, Never>(.loading)
    
    init(publisherClosure: @escaping () -> (AnyPublisher<T, Error>?)) {
        self.publisherClosure = publisherClosure
    }
    
    public var currentValue: T? {
        self.stateSubject.value.value
    }
    
    public func getPublisher() -> AnyPublisher<T, Error> {
        if let inFlightPublisher = inFlightPublisher {
            return inFlightPublisher
        }
        inFlightPublisher = publisherClosure()?
            .handleEvents { [weak self] _ in
                self?.stateSubject.value = .loading
            } receiveOutput: { [weak self] t in
                guard let self = self else {return}
                self.stateSubject.value = .ready(t)
            } receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.stateSubject.value = .failure(error)
                }
                self?.inFlightPublisher = nil
            }.share()
            .eraseToAnyPublisher()
        return inFlightPublisher!
    }
    
    public func reload() {
        getPublisher().sink { _ in } receiveValue: { _ in }.store(in: &self.cancellables)
    }
    
    public func getStateSubject() -> AnyPublisher<DataState<T>, Never> {
        switch stateSubject.value {
        case .ready(_):
            break
        case .failure(_):
            reload()
        case .loading:
            reload()
        }
        return stateSubject.eraseToAnyPublisher()
    }
    
    public func getValuesSubject() -> AnyPublisher<T, Never> {
        switch stateSubject.value {
        case .ready(_):
            break
        case .failure(_):
            reload()
        case .loading:
            reload()
        }
        return stateSubject
            .compactMap {$0.value}
            .eraseToAnyPublisher()
    }
    
    public func requireValue() -> AnyPublisher<T, Error> {
        return getStateSubject()
            .filter { state in
                switch state {
                case .ready(_):
                    return true
                case .failure(_):
                    return true
                case .loading:
                    return false
                }
            }.first()
            .tryMap { state in
                switch state {
                case .loading:
                    fatalError()
                case .ready(let value):
                    return value
                case .failure(let error):
                    throw error
                }
            }.eraseToAnyPublisher()
    }
    
    public func uninitialize() {
        self.stateSubject.value = .loading
    }
    
    public func pushValue(value: T) {
        self.stateSubject.value = .ready(value)
    }
}
