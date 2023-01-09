//
//  SettingsView.swift
//  Tyr's Haiku
//
//  Created by Tyr Zong on 12/29/22.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id, order: .reverse)]) var reminders: FetchedResults<Reminder>
    
    let calendar = Calendar.current
    @State var reminderDate = Date()
    @State var reminderID = UUID()
    @State private var isNotifOn: Bool = false
    
    
    var body: some View {
        List{
            Toggle(
                isOn: $isNotifOn,
                label: {Text("Enable daily notification")}
            )
            .onChange(of: isNotifOn) { value in
                if isNotifOn{
                    addNotification()
                }
                else{
                    if reminders.count != 0{
                        for reminder in reminders{
                            DataController().editReminder(reminder: reminder, date: reminderDate, isOn: isNotifOn, context: managedObjContext)
                        }
                    }
                    deleteAllNotification()
                }
            }
            
            DatePicker("Remind me at: ", selection: $reminderDate, displayedComponents: .hourAndMinute)
                .disabled(isNotifOn == false)
                .onChange(of: reminderDate) { value in
                    addNotification()
                }
        }
        .onAppear(){
            if reminders.count != 0{
                for reminder in reminders{
                    reminderDate = reminder.date!
                    reminderID = reminder.id!
                    isNotifOn = reminder.isOn
                }
            }
        }
    }
    
    private func deleteAllNotification(){
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
    
    private func addNotification(){
        if reminders.count == 0{
            DataController().addReminder(date: reminderDate, uuid: UUID(), isOn: isNotifOn, context: managedObjContext)
        }else{
            for reminder in reminders{
                DataController().editReminder(reminder: reminder, date: reminderDate, isOn: isNotifOn, context: managedObjContext)
            }
        }
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
        datecomponents.hour = calendar.component(.hour, from: reminderDate)
        datecomponents.minute = calendar.component(.minute, from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching:  datecomponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        deleteAllNotification()
        UNUserNotificationCenter.current().add(request)
        print("added new notification \(reminderDate) + \(reminderID)")
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
