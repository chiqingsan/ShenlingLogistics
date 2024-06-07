import { HmNavBar, HmCard, HmCardItem, CommonRouterParams } from '@hm/basic'
import { TaskDetailInfo, TaskDetailInfoModel } from '../../models'
import { router } from '@kit.ArkUI'
import { getTaskDetail } from '../../api'

@Entry
@Component
struct CarRecord {
  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.getTaskDetail(params.id)
    }
  }

  async getTaskDetail(id: string) {
    this.taskDetailData = await getTaskDetail(id)
  }

  build() {
    Column() {
      HmNavBar({ title: '回车登记' })
      Scroll() {
        Column() {
          HmCard() {
            HmCardItem({
              leftTitle: '出车时间',
              rightText: this.taskDetailData.actualDepartureTime
            })
            HmCardItem({
              leftTitle: '回车时间',
              rightText: '请选择',
              showBottomBorder: false
            })
          }
        }
        .height('100%')
      }
      .layoutWeight(1)

      // 底部内容
      Row() {
        Button("交车", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.primary'))
          .width(207)
          .height(50)
      }
      .backgroundColor($r('app.color.white'))
      .height(70)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }
    .backgroundColor($r('app.color.background_page'))
    .height('100%')
  }
}