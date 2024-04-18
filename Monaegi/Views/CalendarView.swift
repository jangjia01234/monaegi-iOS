import SwiftUI

struct CalendarView: View {
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
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("darkGray"))
                    .padding(.horizontal, 20)
                
                calendarGridView
                    .padding(.horizontal, 90)
                    .padding(.vertical, 20)
            }
        }
    }
    
    private var headerView: some View {
        VStack {
            yearMonthView
                .padding(.top, 80)
                .padding(.bottom, 20)
            
            HStack {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
                    Text(Self.weekdaySymbols[symbol].uppercased())
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)
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
                    action: {
                        changeMonth(by: -1)
                    },
                    label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(canMoveToPreviousMonth() ? .gray : .white)
                    }
                )
                .disabled(!canMoveToPreviousMonth())
                
                Button(
                    action: {
                        changeMonth(by: 1)
                    },
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
        .padding(.bottom, 15)
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
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let month = Calendar.current.component(.month, from: date)
                        let clicked = clickedCurrentMonthDates == date
                        let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate
                        
                        CellView(day: day, month: month, clicked: clicked, isToday: isToday)
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        let month = Calendar.current.component(.month, from: prevMonthDate)
                        
                        CellView(day: day, month: month, isCurrentMonthDay: false)
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
    
    private var day: Int
    private var month: Int
    
    private var clicked: Bool
    private var isToday: Bool
    private var isCurrentMonthDay: Bool
    
    private var textColor: Color {
        if clicked {
            return Color.black
        } else if isToday {
            return Color.black
        } else if isCurrentMonthDay {
            return Color.gray
        } else {
            return Color.clear
        }
    }
    
    private var backgroundColor: Color {
        if clicked {
            return Color.white
        } else if isToday {
            return Color.gray
        } else {
            return Color.black
        }
    }
    
    private var rectBgColor: Color {
        if journalState.journals.count > 0 {
            if Int(journalState.journals.first!.date.suffix(2)) == day &&
                Int(journalState.journals.first!.date.split(separator: "-")[1]) == month
            {
                return Color("AccentColor")
            }
        }
    
        if isCurrentMonthDay {
            return Color("darkGray")
        } else {
            return Color.clear
        }
    }
    
    fileprivate init(
        day: Int,
        month: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isCurrentMonthDay: Bool = true
    ) {
        self.day = day
        self.month = month
        self.clicked = clicked
        self.isToday = isToday
        self.isCurrentMonthDay = isCurrentMonthDay
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .cornerRadius(5)
                .frame(width: 25, height: 25)
                .foregroundColor(rectBgColor)
                .padding(.bottom, -5)
        }
        .frame(height: 20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(JournalState())
    }
}
