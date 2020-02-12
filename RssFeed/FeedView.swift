import SwiftUI
import SwiftUIRefresh

struct FeedView: View {

    @State var action: String? = ""
    
    @EnvironmentObject private var data: AppState
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var isAbout = false
    @State private var isUpdating = false
    @State var isDelete = false
    
    //private let mx = DispatchSemaphore(value: 1)
    
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
    
    var body: some View {
    
            VStack(alignment: .center, spacing: 0) {
                
                HeaderView(
                    url: self.url,
                    isDefault: self.url == defaultFeedUrl
                ).frame(height: 100)
                .onLongPressGesture{
                    self.isDelete.toggle()
                }
                    
                List {
                    if self.data.feeds[self.url]?.isWithBreakings ?? false {
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
                    }
                    
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
                trailing: AboutButton(deligate: self, color: Color(.systemBlue))
            )
            .sheet(isPresented: $isAbout) {
                AboutView()
            }
            .actionSheet(isPresented: $isDelete){
                ActionSheet(title: Text("Удаление ленты"), message: Text("вы действительно хотите удалить эту ленту?"), buttons: [
                    .destructive(Text("Удалить")) {
                        self.data.remove(self.url)
                        self.isDelete = false
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    .cancel(Text("Отмена")) {
                        self.isDelete = false
                    }
                ])
            }
        }
    
}

extension FeedView: AboutButtonDeligate {
    func aboutToggle() {
        self.isAbout.toggle()
    }
}


//
