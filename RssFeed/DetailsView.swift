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

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ActivityViewController>
    ) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ActivityViewController>
    ) {}

}


struct DetailsView: View {
    var link: String?
    var title: String?
    
    @State var isShare = false
    
    var body: some View {
        VStack {
            WebView(link: link)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle( Text(title ?? "" ))
        .navigationBarItems(
            trailing: HStack{
                Button(action: {
                    self.isShare.toggle()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.large)
                        .accessibility(label: Text("Share"))
                        .padding()
                        .foregroundColor(Color(.systemBlue))
                }.buttonStyle(PlainButtonStyle())
            }
        )
        .sheet(isPresented: $isShare) {
            ActivityViewController(
                activityItems: [URL(string: self.link ?? "https://apple.com")!]
            )
        }
    }
}





struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(
            link: "https://www.rbc.ru/rbcfreenews/5e3c02f29a7947be05731d62"
        )
    }
}
