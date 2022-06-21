//
//  SessionOnboardingView.swift
//  TriomiCount
//
//  Created by Marvin Lee Kobert on 25.01.22.
//

import SwiftUI
import PageSheetCore

struct SessionOnboardingView: View {
  @StateObject var viewModel = SessionOnboardingViewModel()
  @State private var newPlayerSheetIsShown: Bool = false
  @State private var selectedSort: PlayerListSort = .default

  @FetchRequest(sortDescriptors: PlayerListSort.default.descriptors, animation: .spring())
  var players: FetchedResults<Player>

  var body: some View {
    NavigationView {
      ZStack {
        background

        playerList
      }
      .fullScreenCover(isPresented: $viewModel.sessionIsShown, onDismiss: viewModel.checkForUnfinishedSession) {
        SessionMainView(session: viewModel.session!)
      }
      .navigationTitle(L10n.HomeView.newSession)
      .roundedNavigationTitle()
      .toolbar(content: toolbarContent)
      .onDisappear {
        viewModel.resetState(of: players)
      }
      .pageSheet(isPresented: $newPlayerSheetIsShown, content: AddNewPlayerView.init)
    }
    .tint(.primaryAccentColor)
  }
}

extension SessionOnboardingView {
  private var background: some View {
    Color.primaryBackground
      .ignoresSafeArea()
  }

  private var playerList: some View {
    ScrollView(showsIndicators: false) {
      resumeLastSessionButton

      Divider()

      ForEach(players) { player in
        SessionOnboardingRowView(
          name: player.wrappedName,
          position: viewModel.getPosition(of: player),
          isChosen: viewModel.isPlayerChosen(player)
        )
        .onTapGesture {
          viewModel.toggleIsChosenState(player)
        }
        .padding(.horizontal)
      }
    }
  }

  var buttonIsDisabled: Bool {
    if viewModel.session != nil && viewModel.chosenPlayers.count < 2 {
      return false
    } else if viewModel.chosenPlayers.count > 1 {
      return false
    } else {
      return true
    }
  }

  @ViewBuilder
  private var resumeLastSessionButton: some View {
    Button(action: viewModel.startSession) {
      Text(viewModel.session != nil && viewModel.chosenPlayers.count < 2
           ? "Resume Last Session"
           : "Start New Session"
      )
      .font(.system(.headline, design: .rounded))
    }
    .buttonStyle(.offsetStyle)
    .padding(.horizontal)
    .disabled(buttonIsDisabled)
  }

  private var sortView: some View {
    PlayerListSortView(selectedSortItem: $selectedSort)
      .labelStyle(.iconOnly)
      .onChange(of: selectedSort) { _ in
        players.sortDescriptors = selectedSort.descriptors
      }
  }

  @ToolbarContentBuilder
  func toolbarContent() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      HStack(spacing: 15) {
        sortView
        AddPlayerToolbarButton(newPlayerSheetIsShown: $newPlayerSheetIsShown)
      }
    }
  }
}
