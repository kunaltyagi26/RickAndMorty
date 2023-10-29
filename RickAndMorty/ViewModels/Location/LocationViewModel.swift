//
//  LocationViewModel.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 28/10/23.
//

import Foundation

final class LocationViewModel: ObservableObject {
    private var locations = [Location]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.cellViewModels = self.locations.compactMap {
                    LocationCellViewModel(location: $0)
                }
            }
        }
    }
    private var apiInfo: LocationsResponse.Info?
    
    @Published var cellViewModels = [LocationCellViewModel]()
    @Published var isLoading = false
    
    func fetchLocations(request: Request = Request(endpoint: .location)) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let locationResult = await Service.shared.execute(request, expecting: LocationsResponse.self)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            switch locationResult {
            case .success(let locationsResponse):
                self.apiInfo = locationsResponse.info
                
                if locations.isEmpty {
                    locations = locationsResponse.results
                } else {
                    locations.append(contentsOf: locationsResponse.results)
                }
                
            case .failure(let error):
                print(error)
            }
            
            self.isLoading = false
        }
    }
    
    private func fetchMoreLocations() async {
        guard let nextUrlString = apiInfo?.next,
              let nextUrl = URL(string: nextUrlString),
              let request = Request(url: nextUrl) else {
            return
        }
        
        await self.fetchLocations(request: request)
    }
    
    func checkForMore(_ item: LocationCellViewModel) async {
        let thresholdIndex = cellViewModels.index(cellViewModels.endIndex, offsetBy: -3)
        
        if apiInfo?.next != nil,
           cellViewModels.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            await fetchMoreLocations()
        }
    }
    
    func location(of viewModel: LocationCellViewModel) -> Location? {
        let index = cellViewModels.firstIndex(where: { $0.id == viewModel.id })
        if let index = index {
            return locations[index]
        }
        return nil
    }
}
