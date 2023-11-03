//
//  LocationResidentsCellView.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 29/10/23.
//

import SwiftUI

struct LocationResidentsCellView: View {
    let viewModel: CharacterCollectionViewCellViewModel
    
    init(viewModel: CharacterCollectionViewCellViewModel) {
        self.viewModel = viewModel
    }
    
    let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(alignment: .leading) {
            if let url = viewModel.characterImageURL {
                AsyncImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray
                        .scaledToFit()
                }
                .cornerRadius(8)
            }
            
            if let name = viewModel.characterName {
                Text(name)
                    .font(.system(size: 19))
                    .fontWeight(.medium)
                    .padding(.all, 4)
            }
            
            if let status = viewModel.characterStatus {
                Text(status)
                    .padding([.leading, .bottom], 4)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
        }
    }
}


struct LocationResidentsCellView_Previews: PreviewProvider {
    static var previews: some View {
        LocationResidentsCellView(viewModel: CharacterCollectionViewCellViewModel(character: Character(id: 1, name: "Rick", status: .alive, species: "", type: "", gender: .male, origin: Object(name: "", url: "https://rickandmortyapi.com/api/character/avatar/128.jpeg"), location: Object(name: "", url: ""), image: "", episode: [], url: "", created: "")))
    }
}
