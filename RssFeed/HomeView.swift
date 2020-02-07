
import SwiftUI

struct HomeView: View {
    
    @State var isAbout = false
    
    @EnvironmentObject private var data: Data
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: FeedView()) {
                    RbcHeaderView(updated: data.updeted).frame(height: 100)
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
            if self.data.isLoadedAtLeastOnce {
                return
            }
            
            loadData(to: self.data)
            
            print("start loading feed")
            self.data.isLoadedAtLeastOnce = true
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
