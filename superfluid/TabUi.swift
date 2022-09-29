//
//  TabUi.swift
//  superfluid
//
//  Created by Aaron Anthony on 2022-09-29.
//

import SwiftUI

struct TabUi: View {
    
    enum Tab: Int {
        case journal
        case moves
        case stats
        case plans
        case social
    }
    @State var selectedTab: Tab = .journal
    
    var body: some View {
        TabView(selection: $selectedTab) {
            moves
            journal
            stats
            todo
            social
        }
        .accentColor(.blue)
    }
    
    var journal: some View {
        LogUi()
            .tag(Tab.journal)
            .tabItem {
                Label("log", systemImage: "book")
            }
    }
    
    var moves: some View {
        //TODO: include gif feature
        MovesUi()
            .tag(Tab.journal)
            .tabItem {
                Label("moves", systemImage: "book")
            }
    }
    
    var stats: some View {
        StatsUi()
            .tag(Tab.journal)
            .tabItem {
                Label("stats", systemImage: "book")
            }
    }
    
    var todo: some View {
        PlansUi()
            .tag(Tab.journal)
            .tabItem {
                Label("plans", systemImage: "book")
            }
    }
    
    var social: some View {
        SocialUi()
            .tag(Tab.journal)
            .tabItem {
                Label("social", systemImage: "book")
            }
    }
}

struct TabUi_Previews: PreviewProvider {
    static var previews: some View {
        TabUi()
    }
}
