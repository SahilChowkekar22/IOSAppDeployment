//
//  DigimonDetailView.swift
//  DigiHunt
//
//  Created by Sahil ChowKekar on 3/4/25.
//

import SwiftUI

struct DigimonDetailView: View {
    let digimon: Digimon
    
    @ObservedObject var digimonViewModel : DigimonViewModel

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.3), Color.cyan.opacity(0.3),
                ]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .center ,spacing: 20) {
                // Digimon Image
                if let url = URL(string: digimon.img) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 450)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 5)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 300, height: 450)
                    }
                }
                
                // Digimon Name
                Text(digimon.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                
                // Digimon Level
                Text("Level: \(digimon.level)")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                
                
                
                Spacer()
            }
            .padding()
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        
                        digimonViewModel.addToFavs(digimon )
                    } label: {
                        Image(systemName: "heart")
                    }
                }
            }
            //            .navigationTitle(digimon.name)
        }
    
    }
}

#Preview {
    DigimonDetailView(
        digimon: Digimon(
            name: "Azulongmon",
            img: "https://digimon.shadowsmith.com/img/azulongmon.jpg",
            level: "Mega"), digimonViewModel: DigimonViewModel(
                apiManager: APIServiceManager()))
}
