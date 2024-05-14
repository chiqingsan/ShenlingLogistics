import { TaskListItemModel, TaskListItem, TaskTypeEnum } from '../../../models/task'
import { router } from '@kit.ArkUI'

@Preview
@Component
struct TaskItemCard {
  taskItemData: TaskListItemModel = new TaskListItemModel({} as TaskListItem)

  // 获取按钮可点击
  getBtnEnable() {
    // 有一个可提货的情况下
    if (this.taskItemData.enablePickUp) {
      return true
    }
    const value = this.taskItemData.status.toString()
    // 在途和回车登记
    switch (value) {
      case TaskTypeEnum.Line.toString():
      case TaskTypeEnum.Delivered.toString():
        return true
    }
    return false
  }

  // 获取按钮显示的文本

  getBtnText() {
    // 接口文档写的string,但是实际值是number
    const value = this.taskItemData.status.toString()
    switch (value) {
      case TaskTypeEnum.Waiting.toString():
        return "提货"
      case TaskTypeEnum.Line.toString():
        return "在途"
      case TaskTypeEnum.Conversion.toString():
        return "改派"
      case TaskTypeEnum.Delivered.toString():
        return "已交付"
      case TaskTypeEnum.Deprecated.toString():
        return "已作废"
      case TaskTypeEnum.Finish.toString():
        return "已完成"
      default:
        return ""
    }
  }

  // 去提货
  toPickUp() {
    router.pushUrl({
      url: 'pages/TaskDetail/TaskDetail',
      params: {
        id: this.taskItemData.id
      }
    })
  }

  build() {
    Column() {
      Row() {
        Text(`任务编号：${this.taskItemData.transportTaskId}`)
          .fontSize(16)
          .fontColor($r("app.color.text_primary"))
          .fontWeight(500)
          .lineHeight(22)
      }.justifyContent(FlexAlign.SpaceBetween).width('100%')


      Row() {
        Column() {
          Text("起")
            .fontSize(12)
            .fontColor($r("app.color.white"))
            .backgroundColor($r("app.color.text_primary"))
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
            .backgroundColor($r('app.color.primary'))
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
            .fontColor($r('app.color.text_secondary'))
            .fontSize(14)

          Text(this.taskItemData.endAddress)
            .fontColor($r('app.color.text_secondary'))
            .fontSize(14)
        }
        .margin({ left: 11.5 })
        .padding({ top: 3, bottom: 3 })
        .height("100%")
        // .layoutWeight(1)
        .justifyContent(FlexAlign.SpaceBetween)
      }.height(75).width("100%").margin({ top: 21 })


      Divider()
        .vertical(true)
        .height(2)
        .color($r('app.color.background_divider'))
        .opacity(0.6)
        .margin({ left: 8, right: 8, top: 21 })
      Row() {
        Column() {
          Text('提货时间').fontSize(14).fontColor($r('app.color.text_secondary'))
          Text(this.taskItemData.planDepartureTime)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })
        }.alignItems(HorizontalAlign.Start)

        Button(this.getBtnText(), { type: ButtonType.Capsule })
          .backgroundColor(this.getBtnEnable() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .fontColor($r("app.color.white"))
          .fontSize(14)
          .height(32)
          .width(80)
          .enabled(this.getBtnEnable())
          .onClick(() => {
            this.toPickUp()
          })

      }.justifyContent(FlexAlign.SpaceBetween).width('100%')
    }
    .margin({ left: 15, right: 15, top: 15 })
    .padding({ left: 19.5, right: 19.5, bottom: 18.5, top: 18.5 })
    .borderRadius(10)
    .backgroundColor($r('app.color.white'))

  }
}

export default TaskItemCard