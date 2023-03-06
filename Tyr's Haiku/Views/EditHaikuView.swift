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
    private let pasteBoard = UIPasteboard.general
    
    var haiku: FetchedResults<Haiku>.Element
    
    enum Field{
        case line1, line2, line3, title
    }
    
    @State private var line1 = ""
    @State private var line2 = ""
    @State private var line3 = ""
    @State private var title = ""
    @FocusState private var focusField: Field?
    
    
    private func formatDateString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func copyHaiku(){
        pasteBoard.string = formatDateString(date: haiku.date!) + "\n" + line1 + "\n" + line2 + "\n" + line3 + "\n— inspired by " + title
    }
    
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
                    .submitLabel(.next)
                    .focused($focusField, equals: .line1)
                    .onSubmit{
                        focusField = .line2
                    }
                TextField("\(haiku.line2!)", text:$line2)
                    .submitLabel(.next)
                    .focused($focusField, equals: .line2)
                    .onSubmit{
                        focusField = .line3
                    }
                TextField("\(haiku.line3!)", text:$line3)
                    .submitLabel(.next)
                    .focused($focusField, equals: .line3)
                    .onSubmit{
                        focusField = .title
                    }
                HStack{
                    Text("Inspired by:").foregroundColor(.gray)
                    TextField("\(haiku.title!)", text: $title)
                        .submitLabel(.done)
                        .focused($focusField, equals: .title)
                        .onSubmit {
                            focusField = nil
                        }
                }
            }
            Section{
                HStack{
                    Spacer()
                    Button("Clear"){
                        line1 = ""
                        line2 = ""
                        line3 = ""
                        title = ""
                    }
                    Spacer()
                }
            }
            Section{
                HStack{
                    Spacer()
                    Button("Copy"){
                        copyHaiku()
                    }
                    Spacer()
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
