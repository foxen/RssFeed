
import SwiftUI

struct HomeView: View {
    
    @State var isAbout = false
    
    @EnvironmentObject private var data: Feed
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: FeedView()) {
                    RbcHeaderView(updated: data.pubDate).frame(height: 100)
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
        }.onAppear {
            
            guard !self.data.atOnce else {
                return
            }
            self.data.load(Completor(
                onComplete: {},
                onImagesComplete: {}
            ))
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
