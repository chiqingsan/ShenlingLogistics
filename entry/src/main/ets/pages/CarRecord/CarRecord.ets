import { HmNavBar, HmCard, HmCardItem, CommonRouterParams, HmCheckBox, HmLoading, DateFormat } from '@hm/basic'
import { CarRecordType, CarRecordTypeModel, TaskDetailInfo, TaskDetailInfoModel } from '../../models'
import { promptAction, router } from '@kit.ArkUI'
import { carRecord, getTaskDetail } from '../../api'

@Entry
@Component
struct CarRecord {
  @State carRecord: CarRecordTypeModel = new CarRecordTypeModel({} as CarRecordType)
  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  @State enterTime: string = "请选择"
  loading: CustomDialogController = new CustomDialogController({
    builder: HmLoading(),
    customStyle: true
  })

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.getTaskDetail(params.id)
    }
  }

  // 根据ID请求任务详情
  async getTaskDetail(id: string) {
    this.taskDetailData = await getTaskDetail(id)
  }

  // 回车时间
  endTime(value: Date) {
    const enterTime = value.toJSON().split(".")[0].split("T").join(" ")
    this.enterTime = enterTime
    this.carRecord.endTime = enterTime
  }

  // 检查再提交
  async btnCarRecord() {
    if (!this.carRecord.endTime) {
      promptAction.showToast({ message: '请选择回车时间' })
      return
    }
    this.loading.open()
    this.carRecord.startTime = this.taskDetailData.actualDepartureTime
    // 运输任务id
    this.carRecord.id = this.taskDetailData.transportTaskId // 注意注意再注意
    await carRecord(this.carRecord)
    this.loading.close()
    promptAction.showToast({ message: '回车登记成功' })
    router.clear() // 清空页面栈
    router.replaceUrl({ url: 'pages/Index/Index' })
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
              rightText: this.enterTime,
              showBottomBorder: false,
              onRightClick: () => {
                DatePickerDialog.show({
                  showTime: true,
                  useMilitaryTime: true,
                  onDateAccept: (value: Date) => {
                    this.endTime(value)
                  }
                })
              }
            })
          }

          HmCheckBox({
            value: !!this.carRecord.isBreakRules, title: '车辆违章',
            checkChange: (value) => {
              this.carRecord.isBreakRules = value
            }
          })
          HmCheckBox({
            value: !!this.carRecord.isFault, title: '车辆故障',
            checkChange: (value) => {
              this.carRecord.isFault = value
            }
          })
          HmCheckBox({
            value: !!this.carRecord.isAccident, title: '车辆事故',
            checkChange: (value) => {
              this.carRecord.isAccident = value
            }
          })
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
          .onClick(() => {
            this.btnCarRecord()
          })
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