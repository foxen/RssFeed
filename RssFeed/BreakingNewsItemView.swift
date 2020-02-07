import SwiftUI

struct BreakingNewsItemView: View {
    
    var item: feedItem
    
    let scale: CGFloat = 0.5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    ZStack {
                        VStack {
                            if self.item.image != nil {
                                Image(self.item.image!, scale: 1.0, label: Text(""))
                                    .resizable()
                                    .aspectScale(
                                        srcW: CGFloat(self.item.image!.width),
                                        srcH: CGFloat(self.item.image!.height),
                                        dstW: geometry.size.width,
                                        dstH: geometry.size.height * self.scale
                                    )
                                
                            }
                            Spacer()
                        }
                        VStack {
                            Image("").frame(
                                width:geometry.size.width,
                                height: geometry.size.height * self.scale
                            ).background(
                                LinearGradient(
                                gradient: Gradient(colors: [
                                    .white,
                                    Color(UIColor(
                                        red: 1.0,
                                        green: 1.0,
                                        blue: 1.0,
                                        alpha: 0.1
                                    ))
                                ]),
                                startPoint: .bottom, endPoint: .top
                                )
                            )
                            Spacer()
                        }
                    }
                }.cornerRadius(
                    20
                ).background(Color(.white).cornerRadius(
                    20
                ))
                VStack {
                    Spacer()
                    HStack {
                        Text(self.item.title ?? "")
                            .font(.headline)
                            .shadow(color: Color(.white), radius: 15, x: 0.0, y: 0.0)
                        Spacer()
                    }
                    HStack {
                        
                        Text(
                            makeDateString(self.item.pubDate)
                        )
                        .foregroundColor(Color(.systemBlue))
                        Spacer()
                        
                    }.padding(.top, geometry.size.height * 0.02)
                    
                    HStack {
                        Text(self.item.description ?? "")
                        Spacer()
                    }.padding(.top, geometry.size.height * 0.02)
                    
                    HStack {
                        Spacer()
                        Text(self.item.author ?? ""
                        ).foregroundColor(Color(.lightGray))
                    }.padding(.top, geometry.size.height * 0.02)
                }.padding()
                .cornerRadius(
                    20
                )
            }
        }
        
    }
}

struct BreakingNewsItemView_Previews: PreviewProvider {
    static var previews: some View {
        BreakingNewsItemView(item: feedItem(id: "123"))
            .previewLayout(.fixed(width: 300, height: 600)).background(Color(
            .sRGB, red: 1.0, green: 0.35, blue: 0.3
        ))
    }
}
