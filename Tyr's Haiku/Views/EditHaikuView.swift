//
//  EditHaikuView.swift
//  Tyr's Haiku
//
//  Created by Tyr Zong on 11/30/22.
//

import SwiftUI

struct EditHaikuView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var haiku: FetchedResults<Haiku>.Element
    
    @State private var line1 = ""
    @State private var line2 = ""
    @State private var line3 = ""
    @State private var title = ""
    
    var body: some View {
        Form{
            Section{
                TextField("\(haiku.line1!)", text:$line1)
                    .onAppear{
                        line1 = haiku.line1!
                        line2 = haiku.line2!
                        line3 = haiku.line3!
                        title = haiku.title!
                    }
                TextField("\(haiku.line2!)", text:$line2)
                TextField("\(haiku.line3!)", text:$line3)
                HStack{
                    Text("Inspired by:").foregroundColor(.gray)
                    TextField("\(haiku.title!)", text: $title)
                }
            }
            HStack{
                Spacer()
                Button("Save"){
                    DataController().editHaiku(haiku: haiku, line1: line1, line2: line2, line3: line3, title: title, context: managedObjContext)
                    dismiss()
                }
                Spacer()
            }
        }
    }
}
