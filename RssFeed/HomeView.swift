
import SwiftUI

struct HomeView: View {
    
    @State var isAbout = false
    
    @EnvironmentObject private var data: AppData
    
    var body: some View {
        NavigationView {
            List {
                
                ForEach(
                    self.data.feeds.keys.sorted(),
                    id: \.self
                
                ) { url in
                    NavigationLink(destination: FeedView(url)) {
                        HeaderView(url: url).frame(height: 100)
                    }
                }
            }
            .navigationBarTitle(
                Text("Новостные ленты")
            )
            .navigationBarItems(
                trailing: AboutButton(deligate: self, color: Color(.systemBlue))
            )
            .sheet(isPresented: $isAbout) {
                AboutView()
            }
        }
        .onAppear {
            for (k, feed) in self.data.feeds {
                guard !feed.atOnce else {
                    return
                }
                
                self.data.feeds[k]?.load(Completor(
                    onComplete: {},
                    onImagesComplete: {}
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

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
}

// .environmentObject(Data())
