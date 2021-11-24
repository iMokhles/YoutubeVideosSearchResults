//
//  IMWebViewModel.swift
//  YoutubeVideosSearchResults
//
//  Created by iMokhles on 24/11/2021.
//

import Foundation

class IMWebViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var shouldGoBack: Bool = false
    @Published var title: String = ""
    
    var url: String
    
    init(url: String) {
        self.url = url
    }
}
