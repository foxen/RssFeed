import SwiftUI
import SwiftUIRefresh

struct FeedView: View {

    @State var action: String? = ""
    
    @EnvironmentObject private var data: AppData
    
    private var url: String
    
    init(_ url: String) {
        
        self.url = url
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    @State var isAbout = false
    
    @State private var isUpdating = false
    
    private let mx = DispatchSemaphore(value: 1)
    
    var body: some View {
    
            VStack(alignment: .center, spacing: 0) {
                
                HeaderView(
                    url: self.url
                ).frame(height: 100)
                    
                List {
                    
                    BreakingScrollView(
                        url: self.url
                    )
                    .frame(height: 420)
                    .listRowInsets(EdgeInsets())
                    .padding(.top, 15)
                
                
                    Text("К другим событиям")
                        .font(.headline)
                        .foregroundColor(.white)
                    .padding(.top, 15)
                    
                    ForEach(
                        self.data.feeds[url]?.items
                            .filter{!$0.value.isBreaking}
                            .keys
                            .sorted()
                            .reversed() ?? [],
                        id: \.self) { key in
                            
                        ZStack {
                            FeedItemView(
                                title: self.data.feeds[self.url]?.items[key]?.title ,
                                image: self.data.feeds[self.url]?.images[key],
                                pubDate: self.data.feeds[self.url]?.items[key]?.pubDate
                            )
                            .frame(height: 100)
                            NavigationLink(
                                destination: DetailsView(
                                    link: self.data.feeds[self.url]?.items[key]?.link
                                )
                            ) {
                                EmptyView()
                            }.buttonStyle(PlainButtonStyle())                            
                        }
                        
                    }
                }
                .pullToRefresh(isShowing: $isUpdating) {
                    
                    self.data.feeds[self.url]?.load(Completor(
                        onComplete: {
                            self.isUpdating = false
                            print("data updating completed")
                        },
                        onImagesComplete: {
                            print("images updating completed")
                        }
                    ))
                    
                }
            }
            .background(
                GeometryReader { geo in
                    RadialGradient(gradient: Gradient(
                        colors: [
                            Color(
                                .sRGB, red: 1.0, green: 0.35, blue: 0.3
                            ),
                            Color(
                                .sRGB, red: 0.75, green: 0.8, blue: 1.0
                            )
                        ]),
                        center: UnitPoint(x:0, y:0),
                        startRadius: geo.size.height * 0.33,
                        endRadius: geo.size.height
                    )
                    .edgesIgnoringSafeArea(.all)
                    
                }
            )
            .navigationBarTitle(
                Text("Лента новостей")
            )
            .navigationBarItems(
                trailing: AboutButton(deligate: self, color: Color(.white))
            )
            .sheet(isPresented: $isAbout) {
                AboutView()
            }
        }
    
}

extension FeedView: AboutButtonDeligate {
    func aboutToggle() {
        self.isAbout.toggle()
    }
}


//struct FeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedView()
//    }
//}
