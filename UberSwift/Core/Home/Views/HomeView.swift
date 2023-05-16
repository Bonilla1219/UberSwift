//
//  HomeView.swift
//  UberSwift
//
//  Created by Javier Bonilla on 5/6/23.
//

import SwiftUI

struct HomeView: View {
    //setting variable that will show the search view
    @State private var mapState = MapViewState.noInput
    var body: some View {
        //placing into a Zstack allows us to add the search view at the top
        ZStack(alignment: .top) {
            UberMapViewRepresentable(mapState: $mapState)
                .ignoresSafeArea()
            
            if mapState == .noInput{
                LocationSearchActivationView()
                    .padding(.top, 72)
                    .onTapGesture{
                        withAnimation(.spring()){
                            mapState = .searchingForLocation
                        }
                    }
            } else if mapState == .searchingForLocation{
                LocationSearchView(mapState: $mapState)
            }
            
            MapViewActionButton(mapState: $mapState)
                .padding(.leading)
                .padding(.top, 4)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
