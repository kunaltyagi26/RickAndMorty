//
//  LocationInfoCellView.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 29/10/23.
//

import SwiftUI

struct LocationInfoCellView: View {
    let viewModel: LocationInfoCollectionViewCellViewModel
    
    init(viewModel: LocationInfoCollectionViewCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Text(viewModel.type.displayName)
                .fontWeight(.bold)
                .padding(.leading, 8)
            Spacer()
            Text(viewModel.displayName)
                .padding(.trailing, 8)
        }
        .frame(height: 60)
        .background {
            Color(.secondarySystemBackground)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(viewModel.type.tintColor), lineWidth: 1)
        )
    }
}

struct LocationInfoCellView_Previews: PreviewProvider {
    static var previews: some View {
        LocationInfoCellView(viewModel: LocationInfoCollectionViewCellViewModel(type: .name, value: "Rick"))
    }
}
