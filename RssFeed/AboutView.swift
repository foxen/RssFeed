import SwiftUI

protocol AboutButtonDeligate {
    func aboutToggle()
}

struct AboutButton: View {
    
    var deligate: AboutButtonDeligate
    var color: Color
    
    var body: some View {
        Button(action: { self.deligate.aboutToggle() }) {
            Image(systemName: "questionmark.circle")
                .imageScale(.large)
                .accessibility(label: Text("About"))
                .padding()
                .foregroundColor(self.color)
        }
    }
}

struct AboutView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack{
                VStack{
                    Text("")
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height * 0.6
                    )
                    .background(
                        RadialGradient(
                            gradient: Gradient(
                                colors: [
                                    Color(
                                        UIColor(hex: 0xffd27fff)
                                    ),
                                    Color(
                                        UIColor(hex: 0xce7612ff)
                                    )
                                ]
                            ),
                        center: UnitPoint(x: 0.5, y: 1),
                        startRadius: geo.size.height * 0.12,
                        endRadius: geo.size.height * 0.35
                        )
                        .edgesIgnoringSafeArea(.all)
                    )
                    
                    
                    
                    Text("")
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height * 0.3
                    )
                    .background(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color(
                                        UIColor(hex: 0xa2dbf9ff)
                                    ),
                                    Color(
                                        UIColor(hex: 0x1588c6ff)
                                    )
                                ]
                            ),
                            startPoint: UnitPoint(x: 0.5,y: 0.0),
                            endPoint: UnitPoint(x: 0.5, y: 1.0)
                        )
                        .edgesIgnoringSafeArea(.all)
                    )
                    Text("")
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height * 0.06
                    )
                    .background(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color(
                                        UIColor(hex: 0x1588c6ff)
                                    ),
                                    Color(
                                        UIColor(hex: 0x085c89ff)
                                    )
                                ]
                            ),
                            startPoint: UnitPoint(x: 0.5,y: 0.0),
                            endPoint: UnitPoint(x: 0.5, y: 1.0)
                        )
                        .edgesIgnoringSafeArea(.all)
                    )
                    
                    Text("")
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height * 0.05
                    )
                    .background(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color(
                                        UIColor(hex: 0x085c89ff)
                                    ),
                                    Color(
                                        UIColor(hex: 0x003551ff)
                                    )
                                ]
                            ),
                            startPoint: UnitPoint(x: 0.5,y: 0.0),
                            endPoint: UnitPoint(x: 0.5, y: 1.0)
                        )
                        .edgesIgnoringSafeArea(.all)
                    )
                    
                }
                VStack {
                    Image("notenough")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        height: geo.size.height * 0.55
                    )
                }
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
