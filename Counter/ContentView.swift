//
//  ContentView.swift
//  Counter
//
//  Created by Paul Dmitryev on 09.09.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack(spacing: 32.0) {
            Text("\(viewModel.counter)")

            Button("Increase counter") {
                viewModel.increaseCounter()
            }

            Button("Counter details") {
                viewModel.showDetails()
            }

            Button("Show date") {
                viewModel.showDate()
            }
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                print("NETWORK CALL")
                viewModel.increaseCounter()
            }
        }
        .fullScreenCover(item: $viewModel.cover) { cover in
            /// NavigationLink would be more logical in terms of UX, but `NavigationLink` by
            /// default doesn't have version with optional binding, and I didn't want to bring it
            /// here to keep example as small as possible, so full screen covers will be OK too
            ///
            /// Part below can be improved by introducing some form of Coordinator pattern
            /// that will take care about navigation, and, probably, a view builder, but
            /// let's keep focused on the simplest possible way of doing things
            switch cover {
            case let .currentValue(childViewModel):
                CounterValueView(viewModel: childViewModel)
            case let .showDate(date):
                DateView(dateChanged: date) {
                    viewModel.dismissCover()
                }
            }
        }
    }
}
