//
//  IMWebViewContainer.swift
//  YoutubeVideosSearchResults
//
//  Created by iMokhles on 24/11/2021.
//

import SwiftUI
import WebKit

struct IMWebViewContainer: UIViewRepresentable {
    @ObservedObject var webViewModel: IMWebViewModel
        
        func makeCoordinator() -> IMWebViewContainer.Coordinator {
            Coordinator(self, webViewModel)
        }
        
        func makeUIView(context: Context) -> WKWebView {
            guard let url = URL(string: self.webViewModel.url) else {
                return WKWebView()
            }
            
            let request = URLRequest(url: url)
            let webView = WKWebView()
            webView.navigationDelegate = context.coordinator
            webView.load(request)
            
            return webView
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {
            if webViewModel.shouldGoBack {
                uiView.goBack()
                webViewModel.shouldGoBack = false
            }
        }
}

extension IMWebViewContainer {
    class Coordinator: NSObject, WKNavigationDelegate {
        @ObservedObject private var webViewModel: IMWebViewModel
        private let parent: IMWebViewContainer
        
        init(_ parent: IMWebViewContainer, _ webViewModel: IMWebViewModel) {
            self.parent = parent
            self.webViewModel = webViewModel
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            webViewModel.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webViewModel.isLoading = false
            webViewModel.title = webView.title ?? ""
            webViewModel.canGoBack = webView.canGoBack
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            webViewModel.isLoading = false
        }
    }
}

struct IMWebViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        IMWebViewContainer(webViewModel: IMWebViewModel(url: ""))
    }
}
