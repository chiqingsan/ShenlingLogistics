
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
        return "交货"
      case TaskTypeEnum.Delivered.toString():
        return "回车登记"
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
        Text("起")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r("app.color.text_primary"))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text(this.taskItemData.startAddress)
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 21 }).width('100%')

      Row() {
        Text("止")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r('app.color.primary'))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text(this.taskItemData.endAddress)
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 14.5 }).width('100%')

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