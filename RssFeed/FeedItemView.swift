import SwiftUI

struct FeedItemView: View {
    
    var title: String?
    var image: CGImage?
    var pubDate: Date?
    var body: some View {
        
            VStack {
                HStack {
                    Spacer()
                    Text(makeDateString(self.pubDate))
                        .foregroundColor(Color(.systemBlue))
                        .font(.caption)
                        .padding(.bottom, -5)
                }
                HStack {
                    GeometryReader { geo in
                        HStack {
                    if self.image != nil {
                        Image(
                            self.image!, scale: 1.0, label: Text("")
                        )
                        .resizable()
                        .aspectScale(
                            srcW: CGFloat(self.image!.width),
                            srcH: CGFloat(self.image!.height),
                            dstW: geo.size.width * 0.25,
                            dstH: geo.size.height
                        ).padding(.trailing, -15)
                    }
                    if self.title != nil {
                        Text(self.title!).padding()
                    }
                    
                    
                    Spacer()
                }}
                .background(Color(.white))
                .cornerRadius(10)
            }
            }.background(Color.clear)
        
    }
}

struct FeedItemView_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemView(
            title: "Си Цзиньпин обсудил с Трампом борьбу с коронавирусом",
            image: UIImage(named: "breaking")?.cgImage,
            pubDate: Date()
        )
        .previewLayout(
            .fixed(width: 300, height: 100)
        )
        .background(Color(
            .sRGB, red: 1.0, green: 0.35, blue: 0.3
        ))
        
    }
}
