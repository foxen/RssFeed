//
//  DetailView.swift
//  RssFeed
//
//  Created by Евгений on 07.02.2020.
//  Copyright © 2020 Евгений. All rights reserved.
//

import SwiftUI

import SwiftUI
import WebKit
  
struct WebView: UIViewRepresentable {
    
    var link: String?
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero)
    }

    func updateUIView(_ view: WKWebView, context: UIViewRepresentableContext<WebView>) {
        
        guard let link = self.link, let url = URL(string: link) else {
            return
        }
        
        let request = URLRequest(url: url)

        view.load(request)
    }
}


struct NewsDetailView: View {
    var link: String?
    
    var body: some View {
        VStack {
            WebView(link: link)
        }.navigationBarTitle(Text(""))
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView(
            link: "https://www.rbc.ru/rbcfreenews/5e3c02f29a7947be05731d62"
        )
    }
}
