//
//  LoginFormView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import SwiftUI

struct LoginFormView: View {
    var body: some View {
        VStack {
        
            // email
            ZStack() {
                Text("Email")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: -155, y: -40)
                TextField("", text: .constant(""))
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .frame(width: 349, height: 51)
                    .background(Color(.black).opacity(0.30))
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).inset(by: 0.50).stroke(.white, lineWidth: 1))
            }
            .frame(width: 349, height: 72)
            .padding(.vertical, 5)
            
            // password
            ZStack() {
                Text("Password")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: -140, y: -40)
                SecureField("", text: .constant(""))
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .frame(width: 349, height: 51)
                    .background(Color(.black).opacity(0.30))
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).inset(by: 0.50).stroke(.white, lineWidth: 1))
            }
            .frame(width: 349, height: 72)
            .padding(.vertical, 5)

            NavigationLink(destination: ContentView()
                .navigationBarBackButtonHidden(true)
            ) {
               Text("Login")
                   .font(.system(size: 20, weight: .bold))
                   .foregroundColor(.white)
                   .frame(maxWidth: .infinity, maxHeight: 50)
                   .background(Color(hex: "4FA0FF"))
                   .cornerRadius(5)
                   .padding(.horizontal)
           }
        }
    }
}
