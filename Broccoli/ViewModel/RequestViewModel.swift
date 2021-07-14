//
//  RequestViewModel.swift
//  Broccoli
//
//  Created by Shibo Tong on 13/7/21.
//

import Foundation
import Combine

class RequestViewModel: ObservableObject {
    @Published var isInvited: Bool {
        didSet {
            UserDefaults.standard.setValue(isInvited, forKey: "isInvited")
        }
    }
    
    @Published var name: String = ""
    @Published var nameCheck = false
    
    @Published var email: String = ""
    @Published var emailCheck = false
    
    @Published var confirmEmail: String = ""
    @Published var confirmCheck = false
    
    @Published var onSuccess = false
    
    @Published var alert = false
    
    var isSuccess = true
    var message = ""
    
    private var anyCancellable: Set<AnyCancellable> = []
    
    init() {
        self.isInvited = UserDefaults.standard.bool(forKey: "isInvited")
        
        $name.receive(on: RunLoop.main)
            .map { name in
                let trimmedString = name.trimmingCharacters(in: .whitespaces)
                return trimmedString.count >= 3
            }
            .assign(to: \.nameCheck, on: self)
            .store(in: &anyCancellable)
        
        $email.receive(on: RunLoop.main)
            .map { email in
                return email.isValidEmail
            }
            .assign(to: \.emailCheck, on: self)
            .store(in: &anyCancellable)
        
        Publishers.CombineLatest($email, $confirmEmail).receive(on: RunLoop.main)
            .map { email, confirmEmail in
                return !confirmEmail.isEmpty && (email == confirmEmail)
            }
            .assign(to: \.confirmCheck, on: self)
            .store(in: &anyCancellable)
    }
    
//    func onChangeName() {
//        let trimmedString = name.trimmingCharacters(in: .whitespaces)
//        print(trimmedString)
//        self.nameCheck = trimmedString.count >= 3
//    }
//
//    func onEmailChange() {
//        self.emailCheck = email.isValidEmail
//        onConfirmChange()
//        print(email.isValidEmail)
//    }
//
//    func onConfirmChange() {
//        if !confirmEmail.isEmpty {
//            self.confirmCheck = self.email == self.confirmEmail
//        }
//    }
    
    func onSubmitClick() {
        let urlString = "https://us-central1-blinkapp-684c1.cloudfunctions.net/fakeAuth"
        if emailCheck && confirmCheck && nameCheck {
            let body = ["name": name, "email": email.lowercased()]
            let url = URL(string: urlString)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let response = response as? HTTPURLResponse, let _ = data else {
                    print("no response")
                    return
                }
                
                if response.statusCode == 400 {
                    DispatchQueue.main.async {
                        self.isSuccess = false
                        self.message = "This email address has already in use."
                        self.onSuccess = true
                    }
                } else if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.isSuccess = true
                        self.message = "You are invited to our beta testing."
                        self.onSuccess = true
                        self.isInvited = true
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func onCancelClicked() {
        self.alert = true
    }
    
    func cancelInvitation() {
        self.isInvited = false
        self.isSuccess = true
        self.message = "You have deregistered our beta test successfully"
        self.onSuccess = true
    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
