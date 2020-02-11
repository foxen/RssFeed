import SwiftUI



struct HeaderView: View {

    var url: String
    
    @EnvironmentObject private var data: AppData
    
    var body: some View {
        
        GeometryReader { geometry in
            HStack {
                RbcLogoSymbol()
                    .frame(
                        width: min(
                            geometry.size.width - 30,
                            geometry.size.height - 30
                        )
                    )
            
                VStack {
                    HStack {
                        Text("РБК - Все материалы")
                            .font(.title)
                        Spacer()
                    }
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text(makeUpdatedString(self.data.feeds[self.url]?.pubDate))
                            .foregroundColor(Color(.systemBlue))
                            .font(.caption)
                        }
                    
                }.padding(.horizontal, 15)
            }
            .padding(15)
            .background(Color(.white))
            
        }
    }
    
}

//struct HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        RbcHeaderView(updated: Date()).previewLayout(.fixed(width: 500, height: 150))
//    }
//}
