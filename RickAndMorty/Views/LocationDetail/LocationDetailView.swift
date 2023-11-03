//
//  LocationDetailView.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 28/10/23.
//

import SwiftUI

struct LocationDetailView: View {
    @StateObject var viewModel: LocationDetailViewModel
    
    var gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.datasource) { datasource in
                    Section() {
                        if datasource.key == .info {
                            ForEach(datasource.value) { valueObject in
                                if let vm = valueObject as? LocationInfoCollectionViewCellViewModel {
                                    LocationInfoCellView(viewModel: vm)
                                        .padding(.vertical, 2)
                                        .padding(.horizontal, 8)
                                }
                            }
                        } else if datasource.key == .characters {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(datasource.value) { valueObject in
                                    if let vm = valueObject as? CharacterCollectionViewCellViewModel {
                                        NavigationLink(
                                            destination: {
                                                CharacterDetailView(character: vm.character)
                                            }
                                        ) {
                                            LocationResidentsCellView(viewModel: vm)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchCharacters()
        }
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(viewModel: LocationDetailViewModel(location: Location(id: 1, name: "Earth", type: "Planet", dimension: "abc", residents: [], url: "", created: "")))
    }
}
