//
//  WalletView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/3/24.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct WalletView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    
    private let db = Firestore.firestore() // Firestore instance
    @State private var navigationPath = NavigationPath()

    @State private var userCards: [Card] = [] // Where `Card` is a custom model for wallet data
    
    @State private var selectedCard: Card?

    func fetchUserCards() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }

        db.collection("user_wallets")
            .whereField("userId", isEqualTo: currentUser.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching cards: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No cards found for the user.")
                    return
                }

                self.userCards = documents.compactMap { doc in
                    do {
                        return try doc.data(as: Card.self)
                    } catch {
                        print("Error decoding card data: \(error)")
                        return nil
                    }
                }
            }
    }


    func addCard(cardNumber: String, cardType: String, expDate: String, securityPin: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }

        let cardData: [String: Any] = [
            "cardNumber": cardNumber,
            "cardType": cardType,
            "expDate": expDate,
            "securityPin": securityPin,
            "userId": currentUser.uid
        ]

        db.collection("user_wallets").addDocument(data: cardData) { error in
            if let error = error {
                print("Error adding card: \(error.localizedDescription)")
            } else {
                print("Card added successfully!")
            }
        }
    }


    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                        ZStack {
                            HStack {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "chevron.backward")
                                        .foregroundStyle(Color(hex: "999999"))
                                        .padding(.leading)
                                }
                                Spacer()
                            }
                            
                            Text("Wallet")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.clear)
                        .background(Color(hex: "1C1C1E"))
                        .shadow(
                          color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 10, y: 10
                        )
                        
                        VStack {
                            SectionHeader(title: "Payment Methods")
                                .padding(.bottom, 10)
                            
                            ForEach(userCards) { card in
                                Button(action: {
                                    selectedCard = card
                                }) {
                                    CardRow(
                                        cardType: card.cardType,
                                        cardNumber: card.cardNumber,
                                        expDate: card.expDate,
                                        securityPin: card.securityPin
                                    )
                                }
                            }
                            Button(action: {
                                selectedCard = Card(
                                    id: nil,
                                    cardNumber: "",
                                    cardType: "",
                                    expDate: "",
                                    securityPin: ""
                                )
                            }) {
                                AddRow(label: "Add Payment Method")
                            }
                            
                            SectionHeader(title: "Promotions")
                                .padding(.top)
                            
                            AddRow(label: "Add Promo Code")


                        }
                        .padding(.top, 30)

                        Spacer()
                    }
                    else if orientation.isLandscape(device: .iPhone){}
                    else {}
                }
                
            }   
        }
        .onAppear {
            fetchUserCards()
        }
        .sheet(item: $selectedCard) { card in
            CardDetailsSheet(card: card)
                .environment(\.colorScheme, .dark)
                .onDisappear {
                    fetchUserCards()
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "person.crop.circle.fill")
            Text("Account")
        }
    }
}


#Preview {
    WalletView()
}
