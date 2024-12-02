//
//  ContentView.swift
//  TabViewQuestion
//
//  Created by IrvingHuang on 2024/12/2.
//

import SwiftUI

struct ContentView: View {
    @StateObject var multipleViewModel: MultipleViewModel = MultipleViewModel()
    
    var body: some View {
        MultipleViewPage()
            .environmentObject(multipleViewModel)
    }
}

