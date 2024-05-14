import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { getTaskDetail, pickUp, deliver } from '../../api'
import { HmNavBar, HmToggleCard, HmUpload, HmLoading, ImageList, UploadFile } from 'shenling_common'
import {
  DeliverParamsTypeModel,
  CommonRouterParams,
  TaskDetailInfoModel,
  TaskDetailInfo,
  PickUpParamsModel,
  TaskTypeEnum,
  ExceptionList
} from '../../models'
import call from '@ohos.telephony.call'

@Entry
@Component
struct TaskDetail {
  @State
  loadingText: string = "加载详情中"
  layer: CustomDialogController = new CustomDialogController({
    customStyle: true,
    alignment: DialogAlignment.Center,
    builder: HmLoading({ loadingText: this.loadingText })
  })
  scroll: Scroller = new Scroller() // 属于外力控制
  @State
  taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.getTaskDetail(params.id)
    }
  }

  async onPageShow() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.addExcept) {
      this.taskDetailData.exceptionList = (await getTaskDetail(this.taskDetailData.id)).exceptionList
    }
  }

  // 获取提货的状态
  getPickUpState() {
    return this.taskDetailData.cargoPickUpPictureList?.length > 0 &&
      this.taskDetailData.cargoPictureList?.length > 0 &&
    this.taskDetailData.cargoPickUpPictureList.every(item =>!!item.url) &&
    this.taskDetailData.cargoPictureList.every(item =>!!item.url)
  }

  // 获取交货按钮的状态
  getDeliverState() {
    return this.taskDetailData.deliverPictureList?.length > 0 &&
      this.taskDetailData.certificatePictureList?.length > 0 &&
    this.taskDetailData.deliverPictureList.every(item =>!!item.url) &&
    this.taskDetailData.certificatePictureList.every(item =>!!item.url)
  }

  async getTaskDetail(id: string) {
    this.loadingText = "加载详情中"
    this.layer.open()
    this.taskDetailData = await getTaskDetail(id)
    this.layer.close()
  }

  // 提货方法
  async btnPickUp() {
    this.loadingText = "上传提货中"
    this.layer.open()
    this.taskDetailData.cargoPictureList = await UploadFile(this.taskDetailData.cargoPictureList)
    this.taskDetailData.cargoPickUpPictureList = await UploadFile(this.taskDetailData.cargoPickUpPictureList)
    await pickUp(new PickUpParamsModel({
      id: this.taskDetailData.id,
      cargoPictureList: this.taskDetailData.cargoPictureList,
      cargoPickUpPictureList: this.taskDetailData.cargoPickUpPictureList
    }))
    promptAction.showToast({
      message: '提货成功'
    })
    // 重新加载一下数据即可 后续会处理
    this.getTaskDetail(this.taskDetailData.id)
    this.layer.close()
    this.scroll.scrollEdge(Edge.Top) // 滚到上方去导航
  }

  // 交货方法
  async btnDeliver() {
    this.loadingText = "上传交货中"
    this.layer.open()
    this.taskDetailData.deliverPictureList = await UploadFile(this.taskDetailData.deliverPictureList)
    this.taskDetailData.certificatePictureList = await UploadFile(this.taskDetailData.certificatePictureList)
    await deliver(new DeliverParamsTypeModel({
      id: this.taskDetailData.id,
      certificatePictureList: this.taskDetailData.certificatePictureList,
      deliverPictureList: this.taskDetailData.deliverPictureList
    }))
    promptAction.showToast({
      message: '交货成功'
    })
    // 重新加载一下
    this.getTaskDetail(this.taskDetailData.id)
    this.layer.close()
  }

  @Builder
  getBaseContentItem(item: BaseBuilderClass) {
    Row() {
      Text(item.title).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Row() {
        Text(item.value).fontSize(14).fontColor($r('app.color.text_secondary'))
        if (item.icon) {
          Image(item.icon).width(24).height(24)
            .onClick(() => {
              if (item.iconClick) {
                item.iconClick()
              }
            })
        }
      }
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })
  }

  // 获取基础信息
  @Builder
  getBaseContent() {
    Row() {
      Column() {
        Row() {
          Text("起").baseTextOneStyle()
          Text(this.taskDetailData.startAddress).baseTextTwoStyle()
        }.margin({ top: 21 })

        Row() {
          Text("止").baseTextOneStyle().backgroundColor($r('app.color.primary'))
          Text(this.taskDetailData.endAddress).baseTextTwoStyle()
        }.margin({ top: 14.5 })
      }.alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({
        right: 20
      })

      if (this.taskDetailData.status === TaskTypeEnum.Line) {
        Column() {
          Image($r("app.media.ic_navigation")).width(22).height(22)
          Text("开始导航").fontSize(14).margin({ top: 10, bottom: 10 })
        }.justifyContent(FlexAlign.SpaceBetween)
        .margin({
          top: 20
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Navigation/NavigationPage',
            params: {
              start: this.taskDetailData.startAddress,
              end: this.taskDetailData.endAddress
            }
          })
        })
      }

    }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Center).width('100%')

    Divider().vertical(false).height(2).color($r('app.color.background_divider')).margin({ left: 8, right: 8, top: 21 })
    this.getBaseContentItem({
      title: '任务编号',
      value: this.taskDetailData.transportTaskId
    })
    this.getBaseContentItem({
      title: '联系人',
      value: this.taskDetailData.startHandoverName
    })
    this.getBaseContentItem({
      title: '联系电话',
      value: this.taskDetailData.startHandoverPhone,
      icon: $r('app.media.ic_phone'),
      iconClick: () => {
        call.makeCall(this.taskDetailData.startHandoverPhone)
      }
    })
    this.getBaseContentItem({
      title: '提货时间',
      value: this.taskDetailData.planDepartureTime
    })
    this.getBaseContentItem({
      title: '预计送达时间',
      value: this.taskDetailData.planArrivalTime
    })

  }

  // 司机信息
  @Builder
  getDriverContent() {
    Row() {
      Text(`车牌号`).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Text(this.taskDetailData.licensePlate).fontSize(14).fontColor($r('app.color.text_secondary'))
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })

    Row() {
      Text(`司机姓名`).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Text(this.taskDetailData.driverName).fontSize(14).fontColor($r('app.color.text_secondary'))
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })
  }

  // 运输路线
  @Builder
  getTransLineContent() {
    Row() {
      Column() {
        Text(this.taskDetailData.startProvince)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(22)
          .fontWeight(600)
        Text(this.taskDetailData.startCity).fontSize(14).lineHeight(22)
      }.width(50)

      Image($r("app.media.ic_right_arrow")).width(36).height(16)
      Column() {
        Text(this.taskDetailData.endProvince)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(22)
          .fontWeight(600)
        Text(this.taskDetailData.endCity).fontSize(14).lineHeight(22)
      }.width(50)
    }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Center).width('100%').padding({
      left: 60,
      right: 60
    })
  }

  // 专门负责提货信息的结构
  @Builder
  getPickUpContent() {
    HmUpload({
      title: '请拍照上传货品凭证',
      canUpload: this.taskDetailData.status === TaskTypeEnum.Waiting,
      imgList: this.taskDetailData.cargoPickUpPictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.cargoPickUpPictureList = list
      }
    })
    HmUpload({
      title: '请拍照上传货品照片',
      canUpload: this.taskDetailData.status === TaskTypeEnum.Waiting,
      imgList: this.taskDetailData.cargoPictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.cargoPictureList = list
      }
    })
  }

  // 专门负责交货信息的结构
  @Builder
  getDeliverContent() {
    HmUpload({
      title: '请拍照上传交货货品凭证',
      canUpload: this.taskDetailData.status === TaskTypeEnum.Line,
      imgList: this.taskDetailData.deliverPictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.deliverPictureList = list
      }
    })
    HmUpload({
      title: '请拍照上传交货货品照片',
      canUpload: this.taskDetailData.status === TaskTypeEnum.Line,
      imgList: this.taskDetailData.certificatePictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.certificatePictureList = list
      }
    })
  }

  // 底部按钮结构
  @Builder
  getBottomBtn() {
    //已完成不显示任何按钮
    Row() {
      if (this.taskDetailData.status === TaskTypeEnum.Waiting) {
        Button("延迟收货", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.btn_gray'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .height(50)
          .width(125)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Delay/Delay',
              params: {
                id: this.taskDetailData.id,
                oldTime: this.taskDetailData.planDepartureTime
              }
            })
          })
        Button("提货", { type: ButtonType.Capsule })
          .backgroundColor(this.getPickUpState() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .fontColor($r('app.color.white'))
          .height(50)
          .flexGrow(1)
          .margin({ left: 13 })
          .enabled(this.getPickUpState())
          .onClick(() => {
            this.btnPickUp()
          })
      }
      else if (this.taskDetailData.status === TaskTypeEnum.Line) {
        // 显示上报异常和交货
        Button("上报异常", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.btn_gray'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .height(50)
          .width(125)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/ExceptionReport/ExceptionReport',
              params: {
                id: this.taskDetailData.transportTaskId
              }
            })
          })
        Button("交货", { type: ButtonType.Capsule })
          .fontColor($r('app.color.white'))
          .height(50)
          .flexGrow(1)
          .margin({ left: 13 })
          .backgroundColor(this.getDeliverState() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .enabled(this.getDeliverState())
          .onClick(() => {
            this.btnDeliver()
          })
      }
      else if (this.taskDetailData.status === TaskTypeEnum.Delivered) {
        Row() {
          Button("回车登记")
            .height(50)
            .width('80%')
            .backgroundColor($r('app.color.primary'))
            .fontColor($r('app.color.white'))
            .onClick(() => {
              router.pushUrl({
                url: 'pages/CarRecord/CarRecord',
                params: {
                  id: this.taskDetailData.id
                }
              })
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }

    }
    .width('100%')
    .padding({ left: 15, right: 15 })
    .height(70)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.white'))
    .position({ y: '100%' })
    .translate({ y: -70 })
  }

  // 获取异常信息
  @Builder
  getExceptionContent() {
    ForEach(this.taskDetailData.exceptionList, (item: ExceptionList) => {
      Row() {
        Column() {
          Row() {
            Text("上报时间").fontSize(14).fontColor($r('app.color.text_primary'))
            Text(item.exceptionTime).margin({ left: 20 }).fontColor($r('app.color.text_secondary'))
          }.height(50).alignItems(VerticalAlign.Center).width('100%')

          Row() {
            Text("异常类型").fontSize(14).fontColor($r('app.color.text_primary'))
            Text(item.exceptionType).margin({ left: 20 }).fontColor($r('app.color.text_secondary'))
          }.height(50).alignItems(VerticalAlign.Center).width('100%')

          Row() {
            Text("处理结果").fontSize(14).fontColor($r('app.color.text_primary'))
            Text("继续运输").margin({ left: 20 }).fontColor($r('app.color.text_secondary'))
          }.height(50).alignItems(VerticalAlign.Center).width('100%')
        }

        // 跳转到详情
        Image($r("app.media.ic_btn_more")).width(24).height(24)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/ExceptionReport/ExceptionDetail',
              params: {
                formData: item
              }
            })
          })
      }
      .width('100%')
      .padding({ left: 15, right: 15 })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

    })
  }

  build() {
    Column() {
      HmNavBar({ title: '任务详情' })
      Scroll(this.scroll) {
        // Scroll里面只能有一个组件
        Column() {
          HmToggleCard({ title: '基本信息' }) {
            this.getBaseContent()
          }

          HmToggleCard({ title: '车辆信息' }) {
            this.getTransLineContent()
          }

          HmToggleCard({ title: '司机信息' }) {
            this.getDriverContent()
          }

          if (this.taskDetailData.exceptionList?.length > 0) {
            HmToggleCard({ title: '异常信息' }) {
              this.getExceptionContent()
            }
          }

          if (this.taskDetailData.status === TaskTypeEnum.Waiting ||
            this.taskDetailData.status === TaskTypeEnum.Delivered ||
            this.taskDetailData.status === TaskTypeEnum.Finish
          ) {
            HmToggleCard({ title: '提货信息' }) {
              this.getPickUpContent()
            }
          }


          if (this.taskDetailData.status === TaskTypeEnum.Line ||
            this.taskDetailData.status === TaskTypeEnum.Delivered
            || this.taskDetailData.status === TaskTypeEnum.Finish
          ) {
            HmToggleCard({ title: '交货信息' }) {
              this.getDeliverContent()
            }
          }

        }
        .padding({
          bottom: 130
        })
      }

      if (this.taskDetailData.status !== TaskTypeEnum.Finish) {
        // 只有在非完成情况下 才显示底部按钮
        this.getBottomBtn()
      }
    }.backgroundColor($r('app.color.background_page'))
    .height('100%')
  }
}

@Extend(Text)
function baseTextOneStyle() {
  .fontSize(12)
  .fontColor($r('app.color.white'))
  .backgroundColor($r('app.color.text_primary'))
  .width(22)
  .height(22)
  .borderRadius(11)
  .textAlign(TextAlign.Center)
}

@Extend(Text)
function baseTextTwoStyle() {
  .margin({ left: 11.5 }).fontColor($r('app.color.text_secondary')).fontSize(14).lineHeight(20)
}

class BaseBuilderClass {
  title: string = ""
  value: string = ""
  icon?: ResourceStr = ""
  iconClick?: () => void = () => {
  }
}