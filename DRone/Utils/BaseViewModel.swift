//
//  BaseViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import Combine

enum FetchingState {
    case loading
    case loaded
    case failure
}

class BaseViewModel: ObservableObject {
    

    var bag = Set<AnyCancellable>()
}
