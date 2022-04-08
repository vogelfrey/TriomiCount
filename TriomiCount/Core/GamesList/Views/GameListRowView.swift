//
//  GameListRowView.swift
//  TriomiCount
//
//  Created by Marvin Lee Kobert on 05.04.22.
//

import Inject
import SwiftUI

struct GameListRowView: View {
  let game: Game

  var body: some View {
    ZStack(alignment: .topLeading) {
      Color("SecondaryAccentColor")
        .opacity(1)
        .cornerRadius(20)

      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading, spacing: 3) {
          Text("gameListRowView.session")
            .font(.title2.bold())
          +
          Text(" #\(game.id)")
            .font(.title2.bold())

          HStack(alignment: .firstTextBaseline) {
            Text(LocalizedStringKey("gameListRowView.playedBy")).bold()
            Text(game.playedBy)
              .multilineTextAlignment(.leading)
          }
          .font(.subheadline)
        }

        Spacer()

        Text(game.startedOnAsString)
      }
      .foregroundColor(.white)
      .padding(.horizontal)
      .padding(.vertical, 10)
    }
    .frame(maxWidth: .infinity)
    .listRowSeparator(.hidden)
    .enableInjection()
  }

#if DEBUG
  @ObservedObject private var iO = Inject.observer
#endif
}

struct GameListRowView_Previews: PreviewProvider {
    static var previews: some View {
      GameListRowView(game: Game.allGames().first!)
    }
}
