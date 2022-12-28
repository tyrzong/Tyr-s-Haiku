//
//  ContentView.swift
//  Tyr's Haiku
//
//  Created by Tyr Zong on 11/30/22.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var haikus: FetchedResults<Haiku>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Text("\(totalHaikuCount())")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List{
                    ForEach(haikus) {haiku in
                        NavigationLink(destination: EditHaikuView(haiku: haiku)){
                            HStack{
                                Text("\(haiku.title!)")
                                    .bold()
                                Spacer()
                                Text("\(formatDateString(date: haiku.date!))")
                            }
                        }
                    }
                    .onDelete(perform: deleteHaiku)
                }
                .listStyle(.plain )
            }
            .onAppear(){
                addNotification()
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            .navigationTitle("Tyr's Haikus")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        showingAddView.toggle()
                    }label: {
                        Label("New Haiku", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView){
                AddHaikuView()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func addNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {success, error in
            if success{
                print("all set")
            } else if let error = error{
                print(error.localizedDescription)
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Write a new Haiku"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        var datecomponents = DateComponents()
        datecomponents.hour =  7
        datecomponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching:  datecomponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }

    private func formatDateString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func deleteHaiku(offset: IndexSet)  {
        withAnimation{
            offset.map{haikus[$0]}.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalHaikuCount() -> String{
        if haikus.count == 0{
            return "Write your first Haiku today :)"
        }
        else if haikus.count == 1{
            return "\(haikus.count) haiku written"
        }
        return "\(haikus.count) haikus written"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
