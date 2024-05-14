@Preview
@CustomDialog
@Component
struct HmDateTimePicker {
  controller: CustomDialogController
  cancelText: string = "取消"
  title: string = "选择时间"
  confirmText: string = "完成"
  // 月日的选择列表
  days: string[] = this.getDays()
  // 时
  hours: string[] = Array.from(Array(24), (_: number, i) => i.toString().padStart(2, "0"))
  // 分
  minutes: string[] = Array.from(Array(60), (_: number, i) => i.toString().padStart(2, "0"))

  dayIndex: number = new Date().getDate() - 1
  hourIndex: number = new Date().getHours()
  minIndex: number = new Date().getMinutes()

  // 外界传入的函数
  onFinish: (value: string) => void  = () => {}

  getDays() {
    const year = new Date().getFullYear() // 拿年份
    const month = new Date().getMonth() + 1 // 0 - 11
    // 当前月份到底有多少天
    //
    let days = 31
    const list: number[] = [1,3,5,7,8,10,12] // 31天
    // 如果当前月份是2月 要考虑闰年的问题
    if(month === 2) {
      // 判断当前年是不是闰年
      if((year % 4 === 0 && year % 100 !== 0) || year % 400 === 0) {
        days = 29
      }else {
        days = 28
      }
    }else {
      if(!list.includes(month)) {
        days = 30
      }
    }
    // 这里得到最终当前月有多少天
    let result: string[] = []
    for (let index = 1; index <= days; index++) {
      result.push(`${month}月${index}日`)
    }
   return result
  }
  // 关闭弹窗 要把结果传出去
  btnOK() {
    this.onFinish(`${new Date().getFullYear()}-${(new Date().getMonth() + 1).toString().padStart(2, "0")}-${(this.dayIndex+1).toString().padStart(2, "0")} ${this.hours[this.hourIndex]}:${this.minutes[this.minIndex]}`)
    this.controller.close()
  }
  build() {
    Column() {
      Row() {
        Text(this.cancelText)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .onClick(() => {
            this.controller.close()
          })
        Text(this.title)
          .fontSize(14)
          .fontColor($r('app.color.text_primary'))
        Text(this.confirmText)
          .fontSize(14)
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
             this.btnOK()
          })
      }
      .padding({
        left: 22,
        right: 22
      })
      .height(50)
      .width('100%')
      .border({
        color: $r('app.color.background_divider'),
        width: {
          bottom: 1
        }
      })
      .justifyContent(FlexAlign.SpaceBetween)

      // 再次放置三列
      Row() {
        Text("月日").layoutWeight(1).textAlign(TextAlign.Center) .fontSize(14)
          .fontColor($r('app.color.text_primary'))
        Text("时").layoutWeight(1).textAlign(TextAlign.Center) .fontSize(14)
          .fontColor($r('app.color.text_primary'))
        Text("分").layoutWeight(1).textAlign(TextAlign.Center) .fontSize(14)
          .fontColor($r('app.color.text_primary'))
      }
      .height(50)
      .width('100%')

      // 放置三列的选择器
      Row() {
        TextPicker({ range: this.days, selected: this.dayIndex }).layoutWeight(1)
          .onChange((value: string | string[], index: number | number[]) => {
           this.dayIndex = index as  number
          })
        TextPicker({ range: this.hours, selected: this.hourIndex }).layoutWeight(1)
          .onChange((value: string | string[], index: number | number[]) => {
            this.hourIndex = index as  number
          })
        TextPicker({ range: this.minutes, selected: this.minIndex }).layoutWeight(1)
          .onChange((value: string | string[], index: number | number[]) => {
            this.minIndex = index as  number
          })
      }.height(205)
    }
    .width('100%')
    .backgroundColor($r('app.color.white'))
  }
}

export { HmDateTimePicker }