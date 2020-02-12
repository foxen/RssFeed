
import SwiftUI

struct HomeView: View {
    
    @State var isAbout = false
    @State var isAdd = false
    @State var newFeed = ""
    
    @EnvironmentObject private var data: AppState
    
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
    
    var body: some View {
        NavigationView {
            List {
                
                ForEach(
                    self.data.feeds.keys.sorted(),
                    id: \.self
                
                ) { url in
                    NavigationLink(destination: FeedView(url)) {
                        HeaderView(
                            url: url,
                            isDefault: url == defaultFeedUrl
                        )
                        .frame(height: 100)
                    }
                }
                HStack {
                    Spacer()
                    Button(action: { self.isAdd.toggle() }) {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                            .accessibility(label: Text("Add"))
                            .padding()
                            .foregroundColor(Color(.systemBlue))
                        
                    }
                    Spacer()
                }
                
            }
            .navigationBarTitle(
                Text("Новостные ленты")
            )
            .navigationBarItems(
                trailing: AboutButton(
                    deligate: self, color: Color(.systemBlue)
                )
            )
            .sheet(isPresented: $isAbout) {
                AboutView()
            }
            .sheet(isPresented: $isAdd) {
                VStack {
                    Form {
                        Text("Добавить ленту").padding()
                        HStack {
                            TextField("https://", text: self.$newFeed)
                                .keyboardType(.URL)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                self.isAdd.toggle()
                                let url = self.newFeed
                                self.newFeed = ""
                                if url == "" {
                                    self.isAdd.toggle()
                                    return
                                }
                                self.data.add(url)
                                self.data.feeds[url]?.load(
                                    Completor(
                                        onComplete: {
                                            self.data.update(url)
                                        }
                                    )
                                )
                            }) {
                                Text("Ok")
                            }.padding()
                        }
                    }
                    Spacer()
                }
                
            }
        }
        .onAppear {
            for (url, feed) in self.data.feeds {
                guard !feed.atOnce else {
                    return
                }
                
                self.data.feeds[url]?.load(Completor(
                    onComplete: {
                        print("\(url) completed")
                    }
                ))
            }
        }
    }
}

extension HomeView: AboutButtonDeligate {
    func aboutToggle() {
        self.isAbout.toggle()
    }
}
