import { CommonRouterParams, DateFormat, HmCard, HmCardItem, HmNavBar, HmSelectCard, HmUpload } from '@hm/basic'
import { ExceptionParamsType, ExceptionParamsTypeModel } from '../../models'
import { router } from '@kit.ArkUI'

class ExceptionItemClass {
  name: string = ""
  index: number = 0
}

@Entry
@Component
struct ExceptionReport {
  @State exceptionForm: ExceptionParamsTypeModel = new ExceptionParamsTypeModel({} as ExceptionParamsType)
  @State exceptErrorList: string[] =
    ["发动机启动困难", "不着车、漏油", "照明失灵", "有异常响动", "排烟异常、温度异常", "其他问题"]
  @State selectIndex: number = 0
  // 异常类型弹层
  typeDialog: CustomDialogController = new CustomDialogController({
    builder: HmSelectCard({
      cardContent: () => {
        this.getCardContent()
      }
    }),
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Bottom
  })

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.exceptionForm.transportTaskId = params.id
    }
  }

  // 传入HmSelectCard组件
  @Builder
  getCardContent() {
    ForEach(this.exceptErrorList, (item: string, index: number) => {
      this.getSingleItem(item, index, index !== this.exceptErrorList.length - 1)
    })
  }

  // 单个的渲染选项
  @Builder
  getSingleItem(item: string, index: number, showBorder: boolean) {
    Row() {
      Text(item)
        .fontSize(14)
        .fontColor($r("app.color.text_primary"))
      Image(this.selectIndex === index ? $r("app.media.ic_check_true") : $r("app.media.ic_check_false"))
        .width(32)
        .height(32)
    }
    .onClick(() => {
      this.selectIndex = index // 赋值索引
    })
    .height(60)
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .border({
      color: $r("app.color.background_divider"),
      width: {
        bottom: showBorder ? 1 : 0
      }
    })
  }

  build() {
    Column() {
      HmNavBar({ title: '上报异常' })
      Scroll() {
        Column() {
          HmCard() {
            HmCardItem({
              leftTitle: '异常时间', rightText: this.exceptionForm.exceptionTime || '请选择',
              onRightClick: () => {
                DatePickerDialog.show({
                  showTime: true,
                  useMilitaryTime: true,
                  onDateAccept: (value) => {
                    this.exceptionForm.exceptionTime = DateFormat(value)
                  }
                })
              }
            })
            HmCardItem({ leftTitle: '上报位置', rightText: '请选择' })
            HmCardItem({
              leftTitle: '异常类型', rightText: '请选择', onRightClick: () => {
                this.typeDialog.open()
              }
            })
            HmCardItem({
              leftTitle: '异常描述',
              rightText: '',
              showRightIcon: false,
              showBottomBorder: false
            })
            TextArea({
              placeholder: '请输入异常描述'
            }).height(130).borderRadius(8).placeholderColor($r('app.color.text_secondary')).fontSize(14)
            Text(`0/50`)
              .margin({
                top: -30
              })
              .textAlign(TextAlign.End)
              .width('100%')
              .padding({ right: 15 })
              .fontColor($r('app.color.text_secondary'))
            Row().height(20)

          }

          HmCard() {
            HmUpload({
              title: '上传图片(最多6张)',
              imgList: []
            , canUpload: true
            })
            Row().height(20)
          }
        }
      }.padding({
        bottom: 80
      })
      .layoutWeight(1)


      Row() {
        Button("提交").height(50).width(207).backgroundColor($r('app.color.primary_disabled'))
      }
      .position({
        y: '100%'
      })
      .height(70)
      .translate({
        y: -70
      })
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.white'))
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}