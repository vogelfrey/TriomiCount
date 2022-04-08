//
//  AddPlayerView.swift
//  TriomiCount
//
//  Created by Marvin Lee Kobert on 24.01.22.
//

import SwiftUI

struct AddNewPlayerView: View {
  @Environment(\.dismiss) var dismiss
  @FocusState private var textFieldIsFocused: Bool

  @State private var alertIsShown: Bool = false
  @State private var alertTitle: LocalizedStringKey = ""
  @State private var alertMessage: LocalizedStringKey = ""

  @State private var nameIsValid: Bool = false
  @State private var nameTextFieldText: String = ""

  var body: some View {
    ZStack {
      Color.primaryBackground
        .ignoresSafeArea()

      VStack(alignment: .leading, spacing: 30) {
        HStack {
          Spacer()
          Button("Cancel") {
            dismiss()
          }
          .foregroundColor(.primaryAccentColor)
          .padding(.top)
        }

        Spacer()

        Text("addNewPlayerView.nameLabel.label_text")
          .underline()
          .font(.title3)
          .fontWeight(.semibold)
          .padding(.leading, 20)

        TextField("addNewPlayerView.nameLabel.textfield_text", text: $nameTextFieldText)
          .foregroundColor(.label)
          .padding(.leading, 10)
          .frame(height: 55)
          .frame(maxWidth: .infinity)
          .background(Color.secondaryBackground)
          .cornerRadius(20)
          .padding(.horizontal, 20)
          .textInputAutocapitalization(.words)
          .textContentType(.givenName)
          .disableAutocorrection(true)
          .focused($textFieldIsFocused)
          .onAppear {
            focusTextField()
          }
          .keyboardType(.alphabet)
          .submitLabel(.go)
          .onSubmit {
            createPlayer()
          }
          .onChange(of: nameTextFieldText, perform: { _ in
            if nameTextFieldText.isEmpty {
              alertMessage = "addNewPlayerView.alertTextFieldEmpty.message"
              nameIsValid = false
            } else if nameTextFieldText.count > 20 {
              alertMessage = "addNewPlayerView.alertNameToLong.message"
              nameIsValid = false
            } else {
              nameIsValid = true
            }
          })
          .overlayedAlert(with: alertMessage, bool: nameIsValid)

        Button {
          createPlayer()
        } label: {
          Text("addNewPlayerView.createButton.label_text")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.offsetStyle)
        .padding(.horizontal, 20)
        .disabled(!nameIsValid)

        Spacer()
        Spacer()
      }
      .padding(.horizontal)
      .alert(alertTitle, isPresented: $alertIsShown) {
        Button("OK") { textFieldIsFocused = true }
      } message: {
        Text(alertMessage)
      }
    }
  }

  func focusTextField() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      textFieldIsFocused.toggle()
    }
  }

  func createPlayer() {
    nameTextFieldText = nameTextFieldText.trimmingCharacters(in: .whitespacesAndNewlines)

    if nameTextFieldText.isValidName {
      Player.addNewPlayer(name: nameTextFieldText)
      dismiss()
    } else {
      HapticManager.shared.notification(type: .error)
      nameIsValid = false
    }
  }
}

struct AddNewPlayerView_Previews: PreviewProvider {
  static var previews: some View {
    AddNewPlayerView()
  }
}
