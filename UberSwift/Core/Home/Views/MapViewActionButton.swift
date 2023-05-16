//
//  MapViewActionButton.swift
//  UberSwift
//
//  Created by Javier Bonilla on 5/9/23.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState:MapViewState
    var body: some View {
        Button{
            withAnimation(.spring()){
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    //when the button is clicked on depending on its states
    func actionForState(_ state: MapViewState){
        switch state{
        case .noInput:
            print("DEBUG: No Input")
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected:
            mapState = .noInput
            print("DEBUG: Clear map view...")
        }
    }
    
    func imageNameForState(_ state: MapViewState) -> String{
        switch state{
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected:
            return "arrow.left"
        }
    }
    
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput))
    }
}
