//
//  AppTabView.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI

struct AppTabView: View {
    let container: Container<Any>
    
    var body: some View {
        TabView {
            MarketsView(container: container).tabItem {
                Image(systemName: "1.circle")
                Text("Markets")
            }.tag(0)
            HoldingsView(container: container).tabItem {
                Image(systemName: "2.circle")
                Text("Holdings")
            }.tag(1)
            OrdersView(container: container).tabItem {
                Image(systemName: "3.circle")
                Text("Orders")
            }.tag(2)
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView(container: DependenciesContainerMock())
    }
}
