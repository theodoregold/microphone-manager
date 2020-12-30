//
//  AboutView.swift
//  Microphone Manager
//
//  Created by David Morán on 30/12/20.
//

import SwiftUI

struct AboutView: View, Initializable {
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("This software is under MIT license")
                    .padding(.leading).padding(.trailing)
                Text("You can access to the code throught:")
                    .padding(.leading).padding(.trailing)
                Text("https://github.com/david-moran/microphone-manager")
                    .padding(.leading).padding(.trailing)
                    .foregroundColor(Color.blue)
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: "https://github.com/david-moran/microphone-manager")!)
                    }
            }
            Group {
                Divider()
                    .frame(width: 370, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Icon for this app was designed by rawpixel.com / Freepik")
                    .padding(.leading).padding(.trailing)
                Text("http://www.freepik.com")
                    .padding(.leading).padding(.trailing)
                    .foregroundColor(Color.blue)
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: "http://www.freepik.com")!)
                    }
            }
            Group {
                Divider()
                    .frame(width: 370, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Other used software:")
                    .padding(.leading).padding(.trailing)
                Text("https://github.com/soffes/HotKey")
                    .padding(.leading).padding(.trailing)
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: "https://github.com/soffes/HotKey")!)
                    }
                    .foregroundColor(Color.blue)
                Text("https://github.com/sindresorhus/LaunchAtLogin")
                    .padding(.leading).padding(.trailing)
                    .foregroundColor(Color.blue)
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: "https://github.com/sindresorhus/LaunchAtLogin")!)
                    }
            }
        }
        .padding(.bottom).padding(.top)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
