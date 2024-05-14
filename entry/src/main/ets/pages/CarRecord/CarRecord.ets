import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import {HmLoading, HmNavBar, HmCard, HmCardItem, HmCheckBox, HmDateTimePicker } from 'shenling_common'
import  { getTaskDetail, carRecord } from '../../api'
import { CommonRouterParams, CarRecordTypeModel, CarRecordType, TaskDetailInfo, TaskDetailInfoModel } from '../../models'
@Entry
@Component
struct CarRecord {
  @State
  carRecord: CarRecordTypeModel = new CarRecordTypeModel({} as CarRecordType)
  @State
  taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  dataTimePicker: CustomDialogController = new CustomDialogController({
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Bottom,
    builder: HmDateTimePicker({
      onFinish: (value) => {
        this.carRecord.endTime = value
      }
    })
  })
  @State
  loadingText: string = "回车登记中"
  layer: CustomDialogController = new CustomDialogController({
    customStyle: true,
    alignment: DialogAlignment.Center,
    builder: HmLoading ({ loadingText: this.loadingText })
  })
  aboutToAppear() {
   const params = router.getParams() as CommonRouterParams
    if(params && params.id) {
       this.getTaskDetail(params.id)
    }
  }
 async getTaskDetail (id: string) {
  this.taskDetailData = await getTaskDetail(id)
 }

  // 回车登记
  async btnCarRecord() {
    if (!this.carRecord.endTime) {
      promptAction.showToast({ message: '请选择回车时间' })
      return
    }
    this.layer.open()
    // 这里的回车登记的参数 有个容易犯错的点
    // 回车登记数据的中id 来自于任务详情的中的任务运输id并非id
    this.carRecord.id = this.taskDetailData.transportTaskId
    this.carRecord.startTime = this.taskDetailData.actualDepartureTime // 实际时间

    // 提交回车的登记
    await carRecord(this.carRecord)
    this.layer.close()
    // 任务已经结束了
    router.clear() // 清空前面的跳过的栈
    promptAction.showToast({ message: '回车登记成功', duration: 3000 })
    router.replaceUrl({
      url: 'pages/Index/Index'
    })
  }
  build() {
    Column() {
      HmNavBar({ title: '回车登记' })
      HmCard() {
        HmCardItem({ leftTitle: '出车时间', rightText: this.taskDetailData.actualDepartureTime, showRightIcon: false })
        HmCardItem({ leftTitle: '回车时间', rightText: this.carRecord.endTime || '请选择', showBottomBorder: false,
        onRightClick: () => {
          this.dataTimePicker.open()
        }
        })
      }
      // 三个的组件
      HmCheckBox({ title: '车辆违章', value: !!this.carRecord.isBreakRules,
        checkChange: (value) => {
          this.carRecord.isBreakRules = value
      } })
      HmCheckBox({ title: '车辆故障', value: !!this.carRecord.isFault,
        checkChange: (value) => {
          this.carRecord.isFault = value
        }})
      HmCheckBox({ title: '车辆事故', value: !!this.carRecord.isAccident,
        checkChange: (value) => {
          this.carRecord.isAccident = value
        }})
     Row() {
        Button("交车")
          .height(50)
          .backgroundColor($r("app.color.primary"))
          .width(207)
          .onClick(() => {
             this.btnCarRecord()
          })
     }
     .justifyContent(FlexAlign.Center)
      .backgroundColor($r("app.color.white"))
      .height(70)
      .width('100%')
      .position({
        y: '100%'
      })
      .translate({
        y: -70
      })
    }
    .backgroundColor($r('app.color.background_page'))
    .height('100%')
  }
}