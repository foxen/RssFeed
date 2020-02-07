import SwiftUI
import SwiftUIRefresh

struct FeedView: View {

    @State var action: String? = ""
    
    @EnvironmentObject private var data: Data
    
    init() {
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
    
    @State private var isShowing = false
    
    var body: some View {
    
            VStack(alignment: .center, spacing: 0) {
                
                RbcHeaderView(updated: self.data.updeted).frame(height: 100)
                    
                List {
                    HeadlinesView()
                        .frame(height: 420)
                        .listRowInsets(EdgeInsets())
                    .padding(.top, 15)
                
                
                    Text("К другим событиям")
                        .font(.headline)
                        .foregroundColor(.white)
                    .padding(.top, 15)
                    
                    ForEach(self.data.feed.keys.sorted().reversed(), id: \.self) { key in
                        
                        ZStack {
                            FeedItemView(
                                title: self.data.feed[key]?.title ,
                                image: self.data.feed[key]?.image,
                                pubDate: self.data.feed[key]?.pubDate
                            )
                            .frame(height: 100)
                            NavigationLink(
                                destination: NewsDetailView(
                                    link:self.data.feed[key]?.link
                                )
                            ) {
                                EmptyView()
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }.pullToRefresh(isShowing: $isShowing) {
                    loadData(to: self.data)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isShowing = false
                    }
                }
                
            }
            .background(
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
                    startRadius: 300,
                    endRadius: 800
                )
                .edgesIgnoringSafeArea(.all)
            )
            .navigationBarTitle(
                Text("Лента новостей").foregroundColor(.white)
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


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
