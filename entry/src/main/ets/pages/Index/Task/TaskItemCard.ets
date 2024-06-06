import { TaskInfoItem, TaskInfoItemModel } from '../../../models'

@Preview
@Component
struct TaskItemCard {
  isDelay: boolean = false
  taskItemData: TaskInfoItemModel = new TaskInfoItemModel({} as TaskInfoItem)

  build() {
    Column() {
      Row() {
        Text(`任务编号：${this.taskItemData.transportTaskId}`)
          .fontSize(16)
          .fontColor("#2A2929")
          .fontWeight(500)
          .lineHeight(22)

        if (this.isDelay) {
          Text("已延迟")
            .fontColor($r("app.color.btn_red"))
            .fontSize(12)
            .border({
              width: 1,
              color: $r("app.color.btn_red"),
              radius: 99
            })
            .padding({
              left: 6.5,
              right: 8.5,
              top: 4,
              bottom: 4
            })
        }
      }.justifyContent(FlexAlign.SpaceBetween).width('100%')


      Row() {
        Column() {
          Text("起")
            .fontSize(12)
            .fontColor($r("app.color.white"))
            .backgroundColor("#2A2929")
            .width(22)
            .height(22)
            .borderRadius(11)
            .textAlign(TextAlign.Center)
          Text()
            .height(22)
            .border({
              width: { left: 1.5 },
              color: "#E3E3E3",
              style: BorderStyle.Dashed
            })
          Text("止")
            .fontSize(12)
            .fontColor($r("app.color.white"))
            .backgroundColor("#EF4F3F")
            .width(22)
            .height(22)
            .borderRadius(11)
            .textAlign(TextAlign.Center)
        }
        .height("100%")
        .width(30)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Center)

        Column() {
          Text(this.taskItemData.startAddress)
            .width("95%")
            .fontColor($r("app.color.gray_10"))
            .fontSize(14)
          Text(this.taskItemData.endAddress)
            .fontColor($r("app.color.gray_10"))
            .fontSize(14)
        }
        .margin({ left: 11.5 })
        .padding({ top: 2, bottom: 2 })
        .height("100%")
        // .layoutWeight(1)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
      }.height(75).width("100%").margin({ top: 21 })


      Divider()
        .vertical(false)
        .strokeWidth(1)
        .color("#EEEEEE")
        .margin({
          top: 21,
          bottom: 14.5
        })
      Row() {
        Column() {
          Text('提货时间').fontSize(14).fontColor($r('app.color.text_secondary'))
          Text(this.taskItemData.planDepartureTime)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })
        }.alignItems(HorizontalAlign.Start)

        Button("提货")
          .backgroundColor(1 ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .fontColor($r("app.color.white"))
          .fontSize(14)
          .height(32)
          .width(80)// .enabled(this.getBtnEnable())
          .onClick(() => {
            // this.toPickUp()
          })

      }.justifyContent(FlexAlign.SpaceBetween).width('100%')
    }
    .margin({ left: 15, right: 15, top: 15 })
    .padding({
      left: 19.5,
      right: 19.5,
      bottom: 18.5,
      top: 18.5
    })
    .borderRadius(10)
    .backgroundColor($r('app.color.white'))

  }
}

export default TaskItemCard