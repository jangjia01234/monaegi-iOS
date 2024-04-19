import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var journalState : JournalState
    
    @State var month: Date = Date()
    @State var clickedCurrentMonthDates: Date?
    
    init(
        month: Date = Date(),
        clickedCurrentMonthDates: Date? = nil
    ) {
        _month = State(initialValue: month)
        _clickedCurrentMonthDates = State(initialValue: clickedCurrentMonthDates)
    }
    
    var body: some View {
        VStack {
            headerView
            
            calendarGridView
                .padding(.vertical, 20)
                .padding(.horizontal, 40)
        }
    }
    
    private var headerView: some View {
        VStack {
            yearMonthView
                .padding(.top, 60)
                .padding(.bottom, 15)
            
            HStack {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
                    Text(Self.weekdaySymbols[symbol].uppercased())
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 10)
        }
        .padding(.horizontal, 20)
    }
    
    private var yearMonthView: some View {
        HStack(alignment: .center) {
            Text(month, formatter: Self.calendarHeaderDateFormatter)
                .font(.title.bold())
                .foregroundColor(.white)
            
            Spacer()
            
            HStack {
                Button(
                    action: { changeMonth(by: -1) },
                    label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(canMoveToPreviousMonth() ? .gray : .white)
                    }
                )
                .disabled(!canMoveToPreviousMonth())
                
                Button(
                    action: { changeMonth(by: 1) },
                    label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(canMoveToNextMonth() ? .gray : .white)
                            .padding(.leading, 15)
                    }
                )
                .disabled(!canMoveToNextMonth())
            }
            .font(.system(size: 18))
            .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
    }
    
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let calDate = getDate(for: index)
                        let year = Calendar.current.component(.year, from: calDate)
                        let month = Calendar.current.component(.month, from: calDate)
                        let day = Calendar.current.component(.day, from: calDate)
                        let clicked = clickedCurrentMonthDates == calDate
                        let isToday = calDate.formattedCalendarDayDate == today.formattedCalendarDayDate
                        
                        CellView(year: year, month: month, day: day, clicked: clicked, isToday: isToday, journal: (JournalData(title: "", content: "", date: "")))
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: previousMonth()
                    ) {
                        let year = Calendar.current.component(.year, from: prevMonthDate)
                        let month = Calendar.current.component(.month, from: prevMonthDate)
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        
                        CellView(year: year, month: month, day: day, isCurrentMonthDay: false, journal: (JournalData(title: "", content: "", date: "")))
                    }
                }
                .onTapGesture {
                    if 0 <= index && index < daysInMonth {
                        let date = getDate(for: index)
                        clickedCurrentMonthDates = date
                    }
                }
            }
        }
    }
}

private struct CellView: View {
    @EnvironmentObject var journalState : JournalState
    
    @State var journal: JournalData
    
    private var year: Int
    private var month: Int
    private var day: Int
    private var clicked: Bool
    private var isToday: Bool
    private var isCurrentMonthDay: Bool
    
    private var textColor: Color {
        if isToday { return Color("darkGray") }
        else if isCurrentMonthDay { return .gray }
        else { return .clear }
    }
    
    private var backgroundColor: Color {
        return isToday ? .gray : .black
    }
    
    private var rectBgColor: Color {
        if isCurrentMonthDay {
            if !journalState.journals.isEmpty &&
                (day == Int(journal.date.suffix(2)) &&
                 month == Int(journal.date.split(separator: "-")[1])) {
                return .clear
            }
            return Color("brown")
        } else { return .clear }
    }
    
    fileprivate init(
        year: Int,
        month: Int,
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isCurrentMonthDay: Bool = true,
        journal: JournalData = JournalData(title: "", content: "", date: "")
    ) {
        self.year = year
        self.month = month
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isCurrentMonthDay = isCurrentMonthDay
        self.journal = journal
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .cornerRadius(8)
                .frame(width: 35, height: 35)
                .foregroundColor(rectBgColor)
                .overlay {
                    if journalState.journals.count > 0 &&
                        (day == Int(journalState.journals[0].date.suffix(2)) &&
                        month == Int(journalState.journals[0].date.split(separator: "-")[1])) {
                        Image("grassIcon")
                            .resizable()
                            .frame(width: 40, height: 38)
                    }
                }
                .onTapGesture {
                    if day == Int(journalState.journals[0].date.suffix(2)) {
                        journalState.isShowingList = true
                    } else {
                        journalState.isShowingList = false
                    }
                    
                    if String(month).count == 1 && String(day).count == 1 {
                        journalState.selectedDate = "\(year)-0\(month)-0\(day)"
                    } else if String(month).count == 1 && String(day).count > 1 {
                        journalState.selectedDate = "\(year)-0\(month)-\(day)"
                    } else if String(month).count > 1 && String(day).count == 1 {
                        journalState.selectedDate = "\(year)-\(month)-0\(day)"
                    } else {
                        journalState.selectedDate = "\(year)-\(month)-\(day)"
                    }
                }
        }
        .frame(height: 40)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(JournalState())
    }
}
