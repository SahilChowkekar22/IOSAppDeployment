//
//  DigimonListCell.swift
//  DigiHunt
//
//  Created by Sahil ChowKekar on 3/3/25.
//

import SwiftUI

struct DigimonListCell: View {
    let digimon: Digimon

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                if let url = URL(string: digimon.img) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 4)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }
                }
                VStack(alignment: .leading, spacing: 5) {
                                Text(digimon.name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)

                                Text("Level: \(digimon.level)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 10)
                
                
            }
        }
    }
}

#Preview {
    DigimonListCell(
        digimon: Digimon(
            name: "Azulongmon",
            img: "https://digimon.shadowsmith.com/img/azulongmon.jpg",
            level: "Mega"))
}
