//
//  SessionMainView.swift
//  TriomiCount
//
//  Created by Marvin Lee Kobert on 22.01.22.
//

import SwiftUI
import SFSafeSymbols

struct SessionMainView: View {
  @StateObject var viewModel: SessionViewModel
  @EnvironmentObject var appState: AppState

  // MARK: Body
  var body: some View {
    ZStack {
      Color.primaryBackground
        .ignoresSafeArea()

      switch viewModel.state {
      case .playing:
        SessionView(viewModel: viewModel)
      case .willEnd:
        ZStack {
          SessionView(viewModel: viewModel)
            .blur(radius: 10)
            .allowsHitTesting(false)
          PointsSubmitView()
            .environmentObject(viewModel)
        }
      case .didEnd:
        SessionResultsView()
          .environmentObject(viewModel)
      case .exited:
        Text("Game was exited.")
      }
    }
    .navigationBarHidden(true)
  }
}
