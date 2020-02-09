import SwiftUI

protocol AboutButtonDeligate {
    func aboutToggle()
}

struct AboutButton: View {
    
    var deligate: AboutButtonDeligate
    var color: Color
    
    var body: some View {
        Button(action: { self.deligate.aboutToggle() }) {
            Image(systemName: "questionmark.circle.fill")
                .imageScale(.large)
                .accessibility(label: Text("About"))
                .padding()
                .foregroundColor(self.color)
        }
    }
}

struct AboutView: View {
    var body: some View {
        Text("кузьма с балалайкой")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
