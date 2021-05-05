//
//  Login.swift
//  TextFields
//
//  Created by Ed Barnes on 05/05/2021.
//

import SwiftUI


struct Login: View {
    @EnvironmentObject var service: Service
    @State var email = ""
    @State var password = ""
    @State var showAlert = false
    @State var alertText = ""

    var body: some View {
        let emailBind = Binding(
            get: {self.email},
            set: {self.email = $0}
        )
        let passwordBind = Binding(
            get: {self.password},
            set: {self.password = $0}
        )
        
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                
                Text("BEST APP")
                    .font(.system(size: 40))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding()
                    .clipped()
                    
                TextField("Email", text: emailBind)
                    .modifier(CustomTextField())
                    
                SecureField("Password", text: passwordBind)
                    .modifier(CustomTextField())
                
                Text("Login")
                    .fontWeight(.bold)
                    .modifier(CustomButton(color: fieldsValid() ? .blue : .gray))
                    .shadow(color: .white, radius: 2)
                    .padding(.top, 20)
                    .onTapGesture {
                        self.service.login(email: self.email, password: self.password) { fail in
                            if (fail != nil) {
                                self.showAlert(fail!)
                            }
                        }
                    }
                    .disabled(!fieldsValid())
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(
                EmptyView()
                    .modifier(BackgroundGradient())
                    .blur(radius: 20)
            )
            .edgesIgnoringSafeArea(.all)
            .disabled(self.showAlert)
            .blur(radius: self.showAlert ? 2 : 0)
            
            if showAlert {
                Alert(text: self.alertText, close: {self.showAlert = false})
            }
        }
    }
    
    func fieldsValid() -> Bool {
        return (self.email != "" && self.password != "")
    }
    
    func showAlert(_ message: LoginError) {
        self.alertText = message.rawValue
        self.showAlert = true
    }
}

struct Alert: View {
    var text: String
    var close: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text(text)
            Text("Close")
                .modifier(CustomButton(color: .red))
                .onTapGesture {
                    self.close()
                }
        }
        .frame(width: UIScreen.main.bounds.width * 2 / 3)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .clipped()
        .shadow(color: .white, radius: 3)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
