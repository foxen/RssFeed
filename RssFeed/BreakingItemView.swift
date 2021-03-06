import SwiftUI

struct BreakingNewsItemView: View {
    
    var key: String
    
    var url: String
    
    @EnvironmentObject private var data: AppState
    
    let scale: CGFloat = 0.5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    ZStack {
                        VStack {
                            if self.data.feeds[self.url]?.images[self.key] != nil {
                                Image(self.data.feeds[self.url]!.images[self.key]!, scale: 1.0, label: Text(""))
                                    .resizable()
                                    .aspectScale(
                                        srcW: CGFloat(self.data.feeds[self.url]!.images[self.key]!.width),
                                        srcH: CGFloat(self.data.feeds[self.url]!.images[self.key]!.height),
                                        dstW: geometry.size.width,
                                        dstH: geometry.size.height * self.scale,
                                        fitByWidth: false
                                    )
                                
                            }
                            Spacer()
                        }
                        VStack {
                            Text("").frame(
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
                        Text(self.data.feeds[self.url]?.items[self.key]?.title ?? "")
                            .font(.headline)
                            .shadow(color: Color(.white), radius: 15, x: 0.0, y: 0.0)
                        Spacer()
                    }
                    HStack {
                        
                        Text(
                            self.data.feeds[self.url]?
                                .items[self.key]?.pubDate?
                                    .formatted("dd.MM.yy HH:mm")
                            ?? ""
                        )
                        .foregroundColor(Color(.systemBlue))
                        Spacer()
                        
                    }.padding(.top, geometry.size.height * 0.02)
                    
                    HStack {
                        Text(
                            self.data.feeds[self.url]?.items[self.key]?.description ?? ""
                        )
                        Spacer()
                    }.padding(.top, geometry.size.height * 0.02)
                    
                    HStack {
                        Spacer()
                        Text(
                            self.data.feeds[self.url]?.items[self.key]?.author ?? ""
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
