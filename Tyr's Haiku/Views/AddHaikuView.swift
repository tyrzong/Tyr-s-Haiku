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
    private let pasteBoard = UIPasteboard.general
   
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
        pasteBoard.string = formatDateString(date: Date()) + "\n" + line1 + "\n" + line2 + "\n" + line3 + "\n— inspired by " + title
    }
    
    var body: some View {

        Form{
            Section{
                HStack{
                    TextField("First line", text:$line1)
                        .submitLabel(.next)
                        .focused($focusField, equals: .line1)
                        .onSubmit{
                            focusField = .line2
                        }
                    Text("\(countSyllables(line:line1))/5").foregroundColor(.gray)
                }
                HStack{
                    TextField("Second line", text:$line2)
                        .submitLabel(.next)
                        .focused($focusField, equals: .line2)
                        .onSubmit{
                            focusField = .line3
                        }
                    Text("\(countSyllables(line:line2))/7").foregroundColor(.gray)
                }
                HStack{
                    TextField("Third line", text:$line3)
                        .submitLabel(.next)
                        .focused($focusField, equals: .line3)
                        .onSubmit{
                            focusField = .title
                        }
                    Text("\(countSyllables(line:line3))/5").foregroundColor(.gray)
                }
                HStack{
                    Text("Inspired by:").foregroundColor(.gray)
                    TextField("", text: $title)
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
