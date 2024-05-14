import router from '@ohos.router'
import { HmCard, HmCardItem, HmNavBar, HmUpload, HmDateTimePicker, HmSelectCard, ImageList } from 'shenling_common'
import { ExceptionParamsTypeModel, ExceptionParamsType, CommonRouterParams } from '../../models'
import { exception } from '../../api'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct ExceptionReport {
  @State
  exceptionForm: ExceptionParamsTypeModel = new ExceptionParamsTypeModel({} as ExceptionParamsType)
  // 选择时间弹出 赋值
  dateTime: CustomDialogController = new CustomDialogController({
    builder: HmDateTimePicker({
      onFinish: (value: string) => {
        this.exceptionForm.exceptionTime = value
      }
    }),
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Bottom
  })
  @State
  exceptErrorList: string[] = ["发动机启动困难", "不着车、漏油", "照明失灵", "有异常响动", "排烟异常、温度异常", "其他问题"]
  maxNumber: number = 50
  // 类型弹层
  typeDialog: CustomDialogController = new CustomDialogController({
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Bottom,
    builder: HmSelectCard({
      confirm: () => {
        this.exceptionForm.exceptionType = this.exceptErrorList[this.selectIndex]
      },
      cardContent: () => {
        // 调用一个builder修饰的函数
        this.getCardContent()
      }
    })
  })
  @State
  selectIndex: number = 0

  // 单个的渲染选项
  @Builder
  getSingleItem(item: ExceptionItemClass) {
    Row() {
      Text(item.name).fontSize(14).fontWeight(400).fontColor($r('app.color.text_primary'))
      Row() {
        Image(item.index === this.selectIndex ? $r("app.media.ic_check_true") : $r("app.media.ic_check_false"))
          .width(32)
          .height(32)
      }
      .onClick(() => {
        this.selectIndex = item.index
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .border({
      width: {
        bottom: 1
      },
      color: $r('app.color.background_divider')
    })
    .width('100%')
    .height(60)
  }

  @Builder
  getCardContent() {
    ForEach(this.exceptErrorList, (item: string, index: number) => {
      // 若干个选项
      this.getSingleItem({ name: item, index } as ExceptionItemClass)
    })
  }

  onPageShow() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.address) {
      this.exceptionForm.exceptionPlace = params.address
    }
    if (params && params.id) {
      this.exceptionForm.transportTaskId = params.id
    }
  }

  getBtnEnable() {
    return !!(this.exceptionForm.exceptionDescribe
      &&
    this.exceptionForm.exceptionPlace
      &&
    this.exceptionForm.exceptionType
      &&
    this.exceptionForm.exceptionTime)
  }

  async btnException() {
    await exception(this.exceptionForm)
    promptAction.showToast({
      message: '上报异常成功',
      duration: 3000
    })
    router.back({
      url: 'pages/TaskDetail/TaskDetail',
      params: {
        addExcept: true
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
                this.dateTime.open()
              }
            })
            HmCardItem({
              leftTitle: '上报位置', rightText: this.exceptionForm.exceptionPlace || '请选择',
              onRightClick: () => {
                router.pushUrl({
                  url: "pages/SelectLocation/SelectLocation"
                })
              }
            })
            HmCardItem({
              leftTitle: '异常类型',
              rightText: this.exceptionForm.exceptionType || '请选择',
              onRightClick: () => {
                this.typeDialog.open()
              }
            })
            HmCardItem({ leftTitle: '异常描述', rightText: '', showRightIcon: false, showBottomBorder: false })
            TextArea({
              placeholder: '请输入异常描述',
              text: this.exceptionForm.exceptionDescribe
            })
              .height(130)
              .borderRadius(8)
              .placeholderColor($r('app.color.text_secondary'))
              .fontSize(14)
              .maxLength(this.maxNumber)
              .onChange(value => {
                  this.exceptionForm.exceptionDescribe = value
              })
            Text(`${this.exceptionForm.exceptionDescribe?.length || 0}/${this.maxNumber}`)
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
              maxNumber: 6,
              canUpload: true,
              imgList: this.exceptionForm.exceptionImagesList || [],
              onListChange: (list: ImageList[]) => {
                this.exceptionForm.exceptionImagesList = []
              }
            })
            Row().height(20)
          }
        }
      }
      .padding({
        bottom: 80
      })
      .layoutWeight(1)

      Row() {
        Button("提交")
          .height(50)
          .width(207)
          .backgroundColor(this.getBtnEnable() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .enabled(this.getBtnEnable())
          .onClick(() => {
            this.btnException()
          })
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

class ExceptionItemClass {
  name: string = ""
  index: number = 0
}