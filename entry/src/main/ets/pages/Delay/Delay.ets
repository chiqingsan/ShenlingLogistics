import router from '@ohos.router'
import { HmNavBar, HmCard, HmCardItem, HmDateTimePicker } from 'shenling_common'
import { CommonRouterParams, DelayParamsTypeModel, DelayParamsType } from '../../models'
import { delay } from '../../api'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct Delay {
  @State
  oldTime: string = ""
  maxSizeNumber: number = 50
  @State
  delayForm: DelayParamsTypeModel = new DelayParamsTypeModel({} as DelayParamsType)
  // 选择时间弹出 赋值
  dateTime: CustomDialogController = new CustomDialogController({
    builder: HmDateTimePicker({ onFinish: (value: string) => {
      this.delayForm.delayTime = value
    } }),
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Bottom
  })

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.oldTime && params.id) {
      this.oldTime = params.oldTime
      this.delayForm.id = params.id
    }
  }
  getBtnEnable () {
    return !!(this.delayForm.id && this.delayForm.delayTime && this.delayForm.delayReason)
  }
  async btnDelay () {
    await delay(this.delayForm)
    promptAction.showToast({
      message: '延迟提货成功',
      duration: 3000
    })
    router.back()
  }
  build() {
    Column() {
      HmNavBar({ title: '延迟提货' })
      HmCard() {
        HmCardItem({ leftTitle: '原定时间', rightText: this.oldTime, showRightIcon: false })
        HmCardItem({ leftTitle: '延迟时间', rightText: this.delayForm.delayTime || '不超过两个小时',
          onRightClick: () => {
            this.dateTime.open()
          }
        })
        TextArea({ placeholder: '请输入延迟提货原因', text: this.delayForm.delayReason })
          .height(130)
          .borderRadius(8)
          .backgroundColor($r('app.color.background_page'))
          .margin({
            top: 20
          })
          .maxLength(this.maxSizeNumber)
          .onChange((value) => {
            this.delayForm.delayReason = value
          })
        Text(`${this.delayForm.delayReason?.length || 0}/${this.maxSizeNumber}`)
          .fontColor($r('app.color.text_secondary'))
          .textAlign(TextAlign.End)
          .width('100%')
          .margin({
            top: -30
          })
          .padding({
            right: 15
          })
        Row() {
          Button("提交").width(207)
            .height(50)
            .enabled(this.getBtnEnable())
            .backgroundColor(this.getBtnEnable() ?$r('app.color.primary'):  $r('app.color.primary_disabled'))
            .onClick(() => {
              this.btnDelay()
            })
        }
        .padding({
          top: 20,
          bottom: 20
        })
      }
    }
    .height('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}