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
            calendarGridView
        }
        .padding(.horizontal, 20)
    }
    
    // 🎨 헤더 뷰
    private var headerView: some View {
        VStack {
            yearMonthView
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
            
            HStack {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
                    Text(Self.weekdaySymbols[symbol].uppercased())
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)
        }
    }
    
    // 🎨 연월 표시
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
    
    // 🎨 날짜 그리드 뷰
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
                        let clicked = clickedCurrentMonthDates == date
                        let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate
                        
                        CellView(day: day, clicked: clicked, isToday: isToday)
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        
                        CellView(day: day, isCurrentMonthDay: false)
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

// 🎨 일자 셀 뷰
private struct CellView: View {
    private var day: Int
    private var clicked: Bool
    private var isToday: Bool
    private var isCurrentMonthDay: Bool
    private var textColor: Color {
        if clicked {
            return Color.black
        } else if isCurrentMonthDay {
            return Color.white
        } else {
            return Color.gray
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
    
    fileprivate init(
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isCurrentMonthDay: Bool = true
    ) {
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isCurrentMonthDay = isCurrentMonthDay
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .cornerRadius(10)
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)
                // 🚨 FIX: 초록색 안나오는 문제 디버깅 필요
                .foregroundColor(clicked ? .green : .gray)
            
            Circle()
                .fill(backgroundColor)
                .overlay(
                    Text(String(day))
                        .font(.system(size: 14))
                        .foregroundColor(textColor)
                )
                .frame(width: 20, height: 20)
        }
        .frame(height: 65)
    }
}

// 📱 프리뷰
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
