//
//  ResponseScreen.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import SwiftUI

struct ResponseScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: RequestViewModel
    
    var body: some View {
        VStack {
            switch viewModel.response {
            case.pending:
                ResponseView(
                    image: "waiting.image",
                    title: "Done!",
                    subtitle: "Your submission is under review \n Submission ID: \(viewModel.ID)",
                    captation: "You will receive a confirmation in a short time.",
                    showButton: true,
                    buttonText: "See all requests",
                    buttonAction: {}
                )
            case .accepted:
                ResponseView(
                    image: "accepted.image",
                    title: "Ready to fly!",
                    subtitle: "Your submission was approved \n Confirmation ID: \(viewModel.ID)",
                    captation: "Keep in mind to follow the local reglementations..",
                    showButton: true,
                    buttonText: "See all requests",
                    buttonAction: {}
                )
            case .rejected:
                ResponseView(
                    image: "rejected.image",
                    title: "Your flight was denied!",
                    subtitle: "Your submission didn’t fulfill the requirements.",
                    captation: "Reason: The hour that you requested are too early for a flight.",
                    showButton: true,
                    buttonText: "See all requests",
                    buttonAction: {}
                )
            }
        }
    }
}

struct ResponseScreen_Previews: PreviewProvider {
    static var previews: some View {
        ResponseScreen(viewModel: RequestViewModel())
    }
}
