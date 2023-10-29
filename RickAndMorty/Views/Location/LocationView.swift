//
//  LocationView.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 28/10/23.
//

import SwiftUI

struct LocationView: View {
    @StateObject var viewModel: LocationViewModel
    
    var body: some View {
        ZStack {
            List(viewModel.cellViewModels) { cellViewModel in
                NavigationLink(
                    destination: {
                        if let location = viewModel.location(of: cellViewModel) {
                            LocationDetailView(
                                viewModel: LocationDetailViewModel(location: location)
                            )
                        } else {
                            EmptyView()
                        }
                    }
                ) {
                    LocationCellView(viewModel: cellViewModel)
                }
                .task {
                    await viewModel.checkForMore(cellViewModel)
                }
            }
            .listStyle(.grouped)
            .task {
                await viewModel.fetchLocations()
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .controlSize(.large)
            }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(viewModel: LocationViewModel())
    }
}
