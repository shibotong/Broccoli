//
//  RequestView.swift
//  Broccoli
//
//  Created by Shibo Tong on 13/7/21.
//

import SwiftUI

struct RequestView: View {
    @ObservedObject var vm = RequestViewModel()
    
    var body: some View {
            VStack(spacing: 20) {
                if !vm.isInvited {
                    Text("Request an Invitation for beta testing").foregroundColor(.gray)
                    CustomTextField(title: "Full Name", placeHolder: "At lease 3 characters", text: $vm.name, showError: vm.nameCheck)
                    CustomTextField(title: "Email", placeHolder: "example@example.com", text: $vm.email, showError: vm.emailCheck)
                    CustomTextField(title: "Confirm Email", placeHolder: "Same with your email", text: $vm.confirmEmail, showError: vm.confirmCheck)
                    Spacer()
                    Button(action:{ vm.onSubmitClick() }) {
                        Text("Send").font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.orange))
                    }
                } else {
                    Spacer()
                    Text("Beta")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(.orange)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 25.0).foregroundColor(.orange.opacity(0.3)))
                        .overlay(RoundedRectangle(cornerRadius: 25.0).stroke(Color.orange, lineWidth: 5))
                    Spacer()
                    Text("Yay, you have already registered for our beta testing!").font(.system(size: 30, weight: .bold, design: .rounded))
                    Text("Check your email to see your invitation.").font(.system(size: 15, weight: .bold, design: .rounded))
                    Button(action: { vm.onCancelClicked() }) {
                        Text("Cancel Invite").font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.orange))
                    }
                    
                }
            }
            .padding()
            .navigationTitle("Broccoli & Co.")
            .fullScreenCover(isPresented: $vm.onSuccess, content: {
                CongratulationView(success: vm.isSuccess, message: vm.message, present: $vm.onSuccess)
            })
            .alert(isPresented: $vm.alert, content: {
                Alert(title: Text("Cancel Invite?"), message: Text("Do you want to cancel your invitation of our beta test?"), primaryButton: .default(Text("Yes")) {
                    vm.cancelInvitation()
                }, secondaryButton: .default(Text("No")))
            })
    }
}

struct CustomTextField: View {
    var title: String
    var placeHolder: String
    @State var onEdit = false
    @Binding var text: String
    var showError: Bool
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.system(.subheadline, design: .rounded)).foregroundColor(Color(.secondaryLabel))
            HStack {
                TextField(placeHolder, text: $text, onEditingChanged: { onEdit in
                    self.onEdit = onEdit
                })
                .foregroundColor(.orange)
                .padding(.vertical)
                if showError {
                    Image(systemName: "checkmark")
                        .font(.system(size: 15, weight: .bold, design: .default))
                        .foregroundColor(.orange)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.orange.opacity(0.1)))
                }
            }
            .font(.system(size: 15, weight: .regular, design: .rounded))
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 10).stroke(self.onEdit ? Color.orange : Color.gray.opacity(0.2), lineWidth: 1))
        }
    }
}

struct RequestView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
