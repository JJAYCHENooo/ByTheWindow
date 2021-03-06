//
//  MatchCoupletView.swift
//  ByTheWindow
//
//  Created by 童翰文 on 2020/2/14.
//  Copyright © 2020 JJAYCHEN. All rights reserved.
//

import SwiftUI

struct MatchCoupletView: View {
    @State var input = ""
    @State var output = ""
    @State var tempInput = ""
    @State var tempOutput = ""
    @EnvironmentObject var navigation: NavigationStack
    
    var body: some View {
        ZStack {
            Image("match-couplet-background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                MatchCoupletTitleView()
                
                CoupletInputView(tempInput: $tempInput, input: $input, output: $output)
                
                
                CoupletTextView(title: "上联：", text: $input )
                
                CoupletTextView(title: "下联：", text: $output)
                
                Button(action: {
                    withAnimation(.easeInOut){
                        self.output = "加载中..."
                        self.loadData()
                    }
                }) {
                    Text("对下联")
                        .font(.custom("MaShanZheng-Regular", size: 20))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(-45))
                    .frame(width: 80, height: 80)
                    .background(Color(#colorLiteral(red: 0.7607843137, green: 0.003921568627, blue: 0, alpha: 1)).opacity(0.8))
                        .rotationEffect(.degrees(45))
                    .shadow(color: Color(#colorLiteral(red: 0.7607843137, green: 0.003921568627, blue: 0, alpha: 1)), radius: 10, x: 0, y: 2)
                        .overlay(Rectangle().stroke(Color.white).frame(width: 60, height: 60)
                            .rotationEffect(.degrees(45)))
                }.padding(.top, 40)
                Spacer()
                Image(systemName: "xmark.circle")
                    .padding(.bottom)
                    .onTapGesture {
                        withAnimation() {
                            self.navigation.unwind()
                        }
                }
            }
            .frame(minWidth: 0,  maxWidth: .infinity)
            .padding(.top, 120)
        }
        
    }
    
    func loadData(){
        let urlString = "http://175.24.30.178:5000/chat/couplet/\(self.input)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlString) else {
            print("invalid url, \(urlString)")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Couplet.self, from: data) {
                    DispatchQueue.main.async {
//                        self.result = decodedResponse
                        self.output = decodedResponse.output
                        print(decodedResponse.output)
                    }
                    return
                }
            }
            print("fetch error")
        }.resume()
    }
}

struct MatchCoupletView_Previews: PreviewProvider {
    static var previews: some View {
        MatchCoupletView()
            .previewLayout(.fixed(width: 1112, height: 834))
    }
}

struct CoupletTextView: View {
    var title = "上联："
    @Binding var text:String
    
    var body: some View {
        HStack(alignment: VerticalAlignment.bottom) {
            Text(title)
                .font(.custom("MaShanZheng-Regular", size: 40))
            VStack(spacing: 5) {
                Text(text)
                    .font(.custom("MaShanZheng-Regular", size: 40))
                
                Rectangle()
                    .frame(width: CGFloat(text.count * 80) , height: 1)
                    .foregroundColor(Color(#colorLiteral(red: 0.7607843137, green: 0.003921568627, blue: 0, alpha: 1)))
            }
        }.padding(.top, 50)
    }
}

struct Couplet: Codable {
    var output: String
}


struct CoupletInputView: View {
    @Binding var tempInput:String
    @Binding var input:String
    @Binding var output:String
    var body: some View {
        HStack(spacing: 20) {
            TextField("请输入上联", text: $tempInput)
                .padding(10) .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.7)))
                .frame(width: 400, height: 50)
            
            
            Button(action: {
                withAnimation(.linear){
                    self.input = self.tempInput
                    self.output = ""
                }
            }) {
                Text("确定")
                    .font(.custom("MaShanZheng-Regular", size: 20))
                    .foregroundColor(.white)
                    .frame(width: 70, height: 45)
                    .background(Color(#colorLiteral(red: 0.7607843137, green: 0.003921568627, blue: 0, alpha: 1)).opacity(0.8))
                    .cornerRadius(20)
                    .shadow(color: Color(#colorLiteral(red: 0.7607843137, green: 0.003921568627, blue: 0, alpha: 1)), radius: 10, x: 0, y: 2)
            }
        }.padding(.top)
    }
}

struct MatchCoupletTitleView: View {
    var body: some View {
        HStack {
            SingleWordView(text: "智")
            SingleWordView(text: "能")
            SingleWordView(text: "对")
            SingleWordView(text: "对")
            SingleWordView(text: "联")
        }
        
    }
}

struct SingleWordView: View {
    var text = "智"
    var body: some View {
        ZStack {
            Image("title-background")
                .resizable()
                .frame(width: 60, height: 60)
            Text(text)
                .font(.custom("MaShanZheng-Regular", size: 60))
        }
    }
}
