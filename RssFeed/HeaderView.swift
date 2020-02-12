import SwiftUI



struct HeaderView: View {

    var url: String
    
    var isDefault: Bool
    
    @EnvironmentObject private var data: AppState
    
    var body: some View {
        
        GeometryReader { geometry in
            HStack {
                if self.isDefault {
                    DefaultLogoSymbol()
                    .frame(
                        width: min(
                            geometry.size.width - 30,
                            geometry.size.height - 30
                        )
                    )
                }
                else if self.data.images[self.url] != nil {
                    Image(
                        self.data.images[self.url]!,
                        scale: 1.0,
                        label: Text("")
                    )
                    .resizable()
                    .aspectScale(
                        srcW: CGFloat(self.data.images[self.url]!.width),
                        srcH: CGFloat(self.data.images[self.url]!.height),
                        dstW: min(
                            geometry.size.width - 30,
                            geometry.size.height - 30
                        ),
                        dstH: min(
                            geometry.size.width - 30,
                            geometry.size.height - 30
                        ),
                        fitByWidth: true
                    )
                }
                
                VStack {
                    HStack {
                        Text(
                            self.data.titles[self.url] ?? ""
                        ).font(.title)
                        Spacer()
                    }
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Text(
                            self.data.pubDates[self.url]?.formatted(
                                "обновлена dd.MM.yy в HH:mm"
                            ) ?? ""
                        )
                        .foregroundColor(Color(.darkGray))
                        .font(.caption)
                    }
                }.padding(.horizontal, 15)
            }
            .padding(15)
            .background(Color(.white))
            
        }
    }
    
}
