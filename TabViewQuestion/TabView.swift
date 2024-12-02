//
//  TabView.swift
//  TabViewQuestion
//
//  Created by IrvingHuang on 2024/12/2.
//

import SwiftUI
import OSLog

class MultipleViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    var totalPage: Int = 8
    
    let logger = Logger(subsystem: "LoopPage", category: "viewModel")
    
    deinit {
        print("MultipleViewModel deinit")
        logger.trace("deinit MultipleViewModel")
    }
}


struct MultipleViewPage: View {
    @EnvironmentObject var viewModel: MultipleViewModel
    
    var body: some View {
        TabView(selection: $viewModel.currentPage) {
            LabelPageView(pageIndex: viewModel.totalPage)
                .tag(-1)
            
            ForEach(0..<viewModel.totalPage, id: \.self) { pageIndex in
                LabelPageView(pageIndex: pageIndex)
                    .tag(pageIndex)
            }
            
            LabelPageView(pageIndex: -1)
                .tag(viewModel.totalPage)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .modifier(
            InfiniteLoopModifier(
                currentPage: $viewModel.currentPage,
                totalPage: viewModel.totalPage
            )
        )
        .environment(\.colorScheme, .dark)
    }
}


fileprivate struct InfiniteLoopModifier: ViewModifier {
    @Binding var currentPage: Int
    let totalPage: Int
    
    @State private var previousPage: Int?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if previousPage == nil {
                    previousPage = currentPage
                }
            }
            .onChange(of: currentPage) { oldValue, newPage in
                guard newPage != previousPage else { return }
                
                if newPage == totalPage {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        previousPage = totalPage - 1
                        currentPage = 0
                    }
                }
                else if newPage == -1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        previousPage = 0
                        currentPage = totalPage - 1
                    }
                } else {
                    previousPage = newPage
                }
            }
    }
}
