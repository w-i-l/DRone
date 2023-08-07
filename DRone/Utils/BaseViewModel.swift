//
//  BaseViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    var bag = Set<AnyCancellable>()
}
