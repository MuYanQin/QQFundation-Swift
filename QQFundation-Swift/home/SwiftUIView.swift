//
//  SwiftUIView.swift
//  QQFundation-Swift
//
//  Created by songping on 2023/5/5.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
    @State var text:String?
    var body: some View {
        if #available(iOS 14.0, *) {
            NavigationView {
   
                Text(text ?? "test")
            }
            .navigationTitle("demo")
            .navigationBarItems(trailing:Button("12222", action: {
                                                    text = "124"
            }))
        } else {
            // Fallback on earlier versions
        }
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
