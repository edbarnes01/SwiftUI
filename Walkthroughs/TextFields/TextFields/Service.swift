//
//  Service.swift
//  TextFields
//
//  Created by Ed Barnes on 05/05/2021.
//

import Foundation

enum LoginError: String, Error {
    case wrongFields = "One or more fields was incorrect. Please try again."
}

class Service: ObservableObject {
    @Published private(set) var loggedIn = false
    var testEmail = "ed@test.com"
    var testPassword = "password"
    
    func login(email: String, password: String, failure: @escaping (LoginError?) -> Void) {
        // You would send a request to your backend here
        // but in the meantime:
        if email == testEmail && password == testPassword {
            self.loggedIn = true
        } else {
            failure(.wrongFields)
        }
    }
    
    func logOut() {
        self.loggedIn = false
    }
}
