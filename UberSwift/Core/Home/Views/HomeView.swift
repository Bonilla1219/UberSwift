//
//  HomeView.swift
//  UberSwift
//
//  Created by Javier Bonilla on 5/6/23.
//

import SwiftUI

struct HomeView: View {
    //setting variable that will show the search view
    @State private var showLocationSearchView = false
    var body: some View {
        //placing into a Zstack allows us to add the search view at the top
        ZStack(alignment: .top) {
            UberMapViewRepresentable()
                .ignoresSafeArea()
            
            if !showLocationSearchView{
                LocationSearchActivationView()
                    .padding(.top, 72)
                    .onTapGesture{
                        withAnimation(.spring()){
                            showLocationSearchView.toggle()
                        }
                    }
            } else {
                LocationSearchView(showLocationSearchView: $showLocationSearchView)
            }
            
            MapViewActionButton(showLocationSearchView: $showLocationSearchView)
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
