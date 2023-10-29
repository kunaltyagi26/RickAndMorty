//
//  LocationCellView.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 28/10/23.
//

import SwiftUI

struct LocationCellView: View {
    let viewModel: LocationCellViewModel
    
    init(viewModel: LocationCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.name)
                .font(.system(size: 20))
                .fontWeight(.medium)
                .padding([.top, .bottom], 2)
            Text(viewModel.type)
                .font(.system(size: 17))
                .fontWeight(.regular)
                .foregroundColor(Color(.secondaryLabel))
                .padding([.top, .bottom], 2)
            Text(viewModel.dimension)
                .font(.system(size: 17))
                .fontWeight(.light)
                .foregroundColor(Color(.secondaryLabel))
                .padding([.top, .bottom], 2)
            
        }
    }
}

struct LocationCellView_Previews: PreviewProvider {
    static var previews: some View {
        LocationCellView(viewModel: LocationCellViewModel(location: Location(id: 1, name: "Earth", type: "Planet", dimension: "abc", residents: [], url: "", created: "")))
    }
}
