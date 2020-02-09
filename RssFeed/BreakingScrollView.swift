import SwiftUI

struct item: Identifiable {
    var id: Int
    var image: CGImage
}

struct BreakingView: View {
    
    @EnvironmentObject private var data: Feed
    
    @State var action: String? = ""
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Text("Главное")
                    .font(.headline)
                    .foregroundColor(Color(.white))
                    .padding(.leading, 15)
                ScrollView(
                    .horizontal,
                    showsIndicators: true
                ) {
                    HStack(
                        alignment: .top, spacing: 0
                    ) {
                        ForEach(
                            self.data.items.keys.sorted().reversed(),
                            id: \.self
                        ) { key in
                            
                            ZStack {
                                if self.data.items[key] != nil
                                    && self.data.items[key]!.isBreaking {
                                    BreakingNewsItemView(
                                        item: self.data.items[key]!
                                    ).frame(
                                        width: geo.size.height * 0.6
                                    ).padding(.leading, 15)
                                    
                                    .buttonStyle(PlainButtonStyle())
                                    .onTapGesture {
                                        self.action = key
                                    }
                                    
                                    NavigationLink(
                                        destination: NewsDetailView(
                                            link: self.data.items[key]!.link
                                        ),
                                        tag: key,
                                        selection: self.$action
                                    ) {
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                }
                    
            }
        }
    }
}

struct HeadlinesView_Previews: PreviewProvider {
    static var previews: some View {
        BreakingView().previewLayout(.fixed(width: 500, height: 600)).background(Color(
            .sRGB, red: 1.0, green: 0.35, blue: 0.3
        ))
    }
}


