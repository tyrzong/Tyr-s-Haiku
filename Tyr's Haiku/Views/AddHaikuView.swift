//
//  AddHaikuView.swift
//  Tyr's Haiku
//
//  Created by Tyr Zong on 11/30/22.
//

import SwiftUI

struct AddHaikuView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var line1 = ""
    @State private var line2 = ""
    @State private var line3 = ""
    @State private var title = ""
    
    var body: some View {
        Form{
            Section{
                TextField("First line", text:$line1)
                TextField("Second line", text:$line2)
                TextField("Third line", text:$line3)
                HStack{
                    Text("Inspired by:").foregroundColor(.gray)
                    TextField("", text: $title)
                }
            }
            HStack{
                Spacer()
                Button("Save"){
                    DataController().addHaiku(line1: line1, line2: line2, line3: line3, title: title, context: managedObjContext)
                    dismiss()
                }
                Spacer()
            }
        }
    }
}

struct AddHaikuView_Previews: PreviewProvider {
    static var previews: some View {
        AddHaikuView()
    }
}
