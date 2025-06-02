import SwiftUI

struct ContentView: View {
    let currentDate = Date()
    let calendar = Calendar.current
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.sRGB, red: 0.99, green: 0.96, blue: 0.94).ignoresSafeArea()
                
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("42")
                        .font(.system(size: geometry.size.width * 0.29))
                        .fontWeight(.light)
                    
                    Text("%")
                        .font(.system(size: geometry.size.width * 0.07))
                        .fontWeight(.medium)
                        .baselineOffset(geometry.size.width * 0.02)
                    
                    
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.22)
                HStack(alignment: .firstTextBaseline, spacing: geometry.size.width * 0.04) {
                    ForEach(0..<7){
                        index in
                        let dayData = getDayData(for: index)
                        dayCapsule(dayName: dayData.name, dayNumber: dayData.number, geometry: geometry)
                    }
                    
                }.position(x: geometry.size.width / 2, y: geometry.size.height * 0.73)
                    
            }
            
        }
    }
    func dayCapsule(dayName: String, dayNumber: String, geometry: GeometryProxy) -> some View {
        ZStack{
            Capsule().fill(Color(.sRGB, red: 0.93, green: 0.89, blue: 0.84)).frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.12)
            VStack{
                Circle().fill(Color(.sRGB, red: 0.27, green: 0.42, blue: 0.90)).frame(width: geometry.size.width * 0.04, height: geometry.size.width * 0.04)
                Text(dayName)
                    .font(.system(size: geometry.size.width * 0.044))
                    .fontWeight(.semibold)
                Text(dayNumber)
                    .font(.system(size: geometry.size.width * 0.06))
                    .fontWeight(.bold)
            }
        }
    }
    
    func getDayData(for dayIndex: Int) -> (name: String, number: String) {
            let dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            
            let currentWeekday = calendar.component(.weekday, from: currentDate)
            
            let mondayOffset = 2 - currentWeekday
        
        var currentDateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)
                currentDateComponents.weekday = 2
        guard let mondayDate = calendar.date(from: currentDateComponents) else {
                    return (dayNames[dayIndex], "")
                }
            
            guard let date = calendar.date(byAdding: .day, value: dayIndex, to: mondayDate) else {
                return (dayNames[dayIndex], "")
            }
            
            let dayNumber = String(calendar.component(.day, from: date))
            
            return (dayNames[dayIndex], dayNumber)
        }
            
}

#Preview {
    ContentView()
}
