import SwiftUI

struct item: Identifiable {
    var id: Int
    var image: CGImage
}

struct BreakingScrollView: View {
    
    var url: String
    
    @EnvironmentObject private var data: AppState
    
    @State var action: String? = ""
    
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .leading) {
                if self.data.feeds[self.url]?.isWithBreakings ?? false {
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
                                self.data.feeds[self.url]?.items
                                    .filter{$0.value.isBreaking}
                                    .keys.sorted()
                                    .reversed() ?? [],
                                id: \.self
                            ) { key in
                                ZStack {
                                    if self.data.feeds[self.url]?.items[key] != nil {
                                        BreakingNewsItemView(
                                            key: key,
                                            url: self.url
                                        ).frame(
                                            width: geo.size.height * 0.6
                                        ).padding(.leading, 15)
                                        
                                        .buttonStyle(PlainButtonStyle())
                                        .onTapGesture {
                                            self.action = key
                                        }
                                        
                                        NavigationLink(
                                            destination: DetailsView(
                                                link: self.data.feeds[self.url]?.items[key]?.link
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
}

