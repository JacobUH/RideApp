//
//  DetailView.swift
//  RideApp
//
//  Created by Jacob Rangel on 11/28/24.
//

import SwiftUI

struct InfoDetailSheet: View {
    
    @Environment(\.dismiss) var dismiss
    let label: String
    let text: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let attributedText = try? AttributedString(
                    markdown: text,
                    options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
                ) {
                    Text(attributedText)
                        .padding(.horizontal)
                        .lineSpacing(8)
                        .multilineTextAlignment(.leading)
                } else {
                    Text("Error parsing text.")
                        .padding(.horizontal)
                }
            }
            .navigationTitle(label)
            
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
