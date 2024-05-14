import DayJs from 'dayjs'
class DayItem {
  date: number  = 0 // 日
  year: number = 0 // 年
  month: number = 0 // 月
  isSelected?: boolean = false // 当前天是否被选择
}

class DateResult {
  year: string = ""
  month: string = ""
}
@Preview
@Component
struct HmCalendar {
  @Prop
  @Watch("updateCurrentDate")
  currentDate: string
  weeks: string[] =  ["周日","周一","周二","周三","周四","周五","周六"]
  @State
  days: DayItem[] = []
  @State
  str: string = ""
  format: string = "YYYY-MM-DD" // 序列化日期的格式
  changeMonth: (value: DateResult) => void  = () => {} // 给定一个初始值
  updateCurrentDate () {
    this.days = this.getDays(this.currentDate) // 日期发生了变化 重新生成date
  }
  // 生成六周42天的日期 包含上个月的 包含这个月的  包含下个月的
  getDays(dateStr: string) {
    const len = 42 // 总长度
    const days: DayItem[] = []
    const date = dateStr ?  DayJs(dateStr) : DayJs() // DayJS不传值的话认为是当前时间
    // 当前月有多少天
    const currDays =  date.daysInMonth()  // 拿到当前月有多少天

    // 先去算当前月的数据
    for (let index = 1; index <= currDays; index++) {
      days.push({
        date: index,
        month: date.month() + 1,
        year: date.year(),
        isSelected: date.month() === DayJs().month() && index === DayJs().date() && date.year() === DayJs().year()
      })
    }
    // 上个月的数据
    const prevMonth = date.date(0) // 上个月最后一天的日期对象
    const prevMonthLastDate =  prevMonth.date() // 31 上个月的最后一天//
    // 要判断一下 上个月的最后一天是周几
    const prevDays = prevMonth.day()
    // 取到周几
    if(prevDays < 6) {
      for (let index = 0; index <= prevDays; index++) {
        days.unshift({
          year: prevMonth.year(),
          month: prevMonth.month() + 1,
          date: prevMonthLastDate - index
        })
      }
    }

    // 算下个月的
    const  nextMonth = date.date(currDays + 1) // 得到下个月的实际的第一天的日期对象
    const start = days.length
    for (let index = 1; index <= len - start; index++) {
       days.push({
         year: nextMonth.year(),
         month: nextMonth.month() + 1,
         date: index
       })

    }
    return days
  }
  aboutToAppear() {
    this.days = this.getDays(this.currentDate)
  }
  // 是否在当前月
  inTheMonth (month: number) {
    return DayJs(this.currentDate).month() === month - 1
  }
  build() {
   Column() {
     // 年月的布局
     Row({ space: 20 }) {
        Image($r('app.media.ic_date_right'))
          .width(30)
          .height(30)
          .rotate({ angle: 180 })
          .onClick(() => {
            // 将月份赋值 -1
           this.currentDate = DayJs(this.currentDate).subtract(1, 'month').format(this.format)
            this.changeMonth({ year: DayJs(this.currentDate).year().toString(), month: (DayJs(this.currentDate).month() + 1).toString() })
          })
       Text(DayJs(this.currentDate).format("YYYY年MM月"))
       Image($r('app.media.ic_date_right'))
         .width(30)
         .height(30)
         .onClick(() => {
           // +1
           this.currentDate = DayJs(this.currentDate).add(1, 'month').format(this.format)
           this.changeMonth({ year: DayJs(this.currentDate).year().toString(), month: (DayJs(this.currentDate).month() + 1).toString() })
         })
     }
     .width('100%')
     .justifyContent(FlexAlign.Center)
     .padding(15)
    Text(this.str)
     // 排列周几的名称
     GridRow({ columns: 7 }) {
       // 子组件
       ForEach(this.weeks, (item: string) => {
         GridCol() {
           Text(item)
             .fontColor($r('app.color.text_secondary'))
             .fontSize(12)
         }
         .height(40)
       })

       // 要放置42天的内容
       ForEach(this.days, (item: DayItem) => {
         GridCol(){
           Column() {
             Text(item.date.toString())
               .textAlign(TextAlign.Center)
               .width(32)
               .height(32)
               .fontSize(14)
               .fontColor(item.isSelected ? $r('app.color.white') :  (this.inTheMonth(item.month) ? $r('app.color.text_primary') :  $r('app.color.text_secondary'))  )
               .backgroundColor(item.isSelected ? $r('app.color.primary') : $r('app.color.white'))
               .borderRadius(item.isSelected ? 16 : 0)

           }
           .alignItems(HorizontalAlign.Center)

         }
       })

     }
   }
    .backgroundColor($r('app.color.white'))
  }
}

export { HmCalendar }