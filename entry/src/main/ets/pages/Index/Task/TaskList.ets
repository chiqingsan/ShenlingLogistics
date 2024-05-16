import { TaskListParamsModel, TaskTypeEnum, TaskListParams, TaskListItemModel } from '../../../models'
import { getTaskList } from '../../../api'
import TaskItemCard from './TaskItemCard'
import { HmLoading, HmList } from 'shenling_common'
import promptAction from '@ohos.promptAction'

@Component
struct TaskList {
  @State
  queryParams: TaskListParamsModel = new TaskListParamsModel({
    page: 1,
    pageSize: 5,
    status: TaskTypeEnum.Waiting
  } as TaskListParams)
  @State
  taskListData: TaskListItemModel[] = []
  @State
  reset: boolean = false // 重置状态
  @State
  allPage: number = 1 // 总页数
  layer: CustomDialogController = new CustomDialogController({
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Center,
    builder: HmLoading()
  })
  theStatusOfTheGoods: Record<string, string> = {
    "1": "待提货",
    "2": "在途",
    "6": "已完成"
  }

  async getTaskList(append: boolean) {
    const result = await getTaskList(this.queryParams)
    // ...是限制使用，在数组中可用
    if (append) {
      this.taskListData = this.taskListData.concat(result.items || [])
    } else {
      this.taskListData = result.items || []
    }

    this.allPage = result.pages // 取到总页数
    this.queryParams.page++ // 下一次的请求的页码
  }

  // 下拉刷新的方法
  async onRefresh() {
    this.allPage = 1 // 总页数也得回到第一页
    this.queryParams.page = 1 // 页码重置第一页
    await this.getTaskList(false)
    promptAction.showToast({
      message: '刷新成功'
    })
  }

  @Builder
  renderItem(item: object) {
    TaskItemCard({ taskItemData: item as TaskListItemModel })
  }

  addZero(value: number) {
    return value.toString().padStart(2, "0")
  }

  // 获取搜索按钮的可用行
  getSearchEnable() {
    return !!(this.queryParams.startTime && this.queryParams.endTime)
  }

  @Builder
  getSearchForm() {
    Column() {
      Row() {
        Search({ placeholder: '请输入任务编号', value: this.queryParams.transportTaskId || '' })
          .backgroundColor($r('app.color.background_page'))
          .height(32)
          .onChange(value => {
            this.queryParams.transportTaskId = value
          })
          .onSubmit(async (value) => {
            this.layer.open()
            this.queryParams.page = 1 // 不论什么条件变化 都会从第一页开始查
            if (value) {
              // value有值的情况下
              // 处理非数字类型无响应的情况
              this.queryParams.startTime = ''
              this.queryParams.endTime = ''
              this.queryParams.transportTaskId = isNaN(parseInt(value)) ? "0" : value
              this.reset = false
              this.allPage = 0 // 相当于锁死条件 不可能出现第二条
            } else {
              this.allPage = 1 // 没值意味着查不到 重新回到列表型状态
              this.queryParams.transportTaskId = "" // id设置为空
            }
            const result = await getTaskList(this.queryParams)
            this.taskListData = result.items || []
            this.layer.close()
          })
      }
      .justifyContent(FlexAlign.Center)
      .padding({ left: 8, right: 8, bottom: 5 })

      Row() {
        // 完成搜索页需要测试点击之后键盘和弹层同时弹出的情况
        Button(this.queryParams.startTime || '开始时间')
          .fontSize(14)
          .width(106)
          .height(32)
          .padding({ left: 0, right: 0 })
          .fontColor('#999')
          .backgroundColor($r('app.color.background_page'))
          .onClick(() => {
            DatePickerDialog.show({
              selected: new Date(),
              onAccept: (value: DatePickerResult) => {
                this.queryParams.startTime =
                  `${value.year}-${this.addZero(value.month! + 1)}-${this.addZero(value.day)}`
              }
            })
          })

        Text("至")
        Button(this.queryParams.endTime || '结束时间')
          .fontSize(14)
          .width(110)
          .height(32)
          .padding({ left: 0, right: 0 })
          .fontColor('#999')
          .backgroundColor($r('app.color.background_page'))
          .onClick(() => {
            DatePickerDialog.show({
              selected: new Date(),
              onAccept: (value: DatePickerResult) => {
                this.queryParams.endTime =
                  `${value.year}-${this.addZero(value.month! + 1)}-${this.addZero(value.day)}`
              }
            })
          })
        Button(this.reset ? "重置" : "筛选")
          .backgroundColor(this.getSearchEnable() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .height(32)
          .width(60)
          .enabled(this.getSearchEnable())
          .onClick(async () => {
            this.queryParams.transportTaskId = ''
            if (this.reset) {
              this.queryParams.startTime = ""
              this.queryParams.endTime = ""
              this.reset = false
            } else {
              this.reset = true
            }
            this.layer.open()
            this.allPage = 1
            this.queryParams.page = 1
            await this.getTaskList(false)
            this.layer.close()
          })
      }.width('100%').alignItems(VerticalAlign.Center).justifyContent(FlexAlign.SpaceAround)
    }
    .backgroundColor($r('app.color.white'))
    .padding(15)
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }

  build() {
    Column() {
      // 只有状态为已完成时 才有搜索
      if (this.queryParams.status === TaskTypeEnum.Finish) {
        this.getSearchForm()
      }
      // if (this.taskListData.length != 0) {
      HmList({
        // 数据源
        dataSource: this.taskListData,
        // 是否结束
        finished: this.allPage < this.queryParams.page,
        // 下拉刷新函数
        onRefresh: async () => {
          await this.onRefresh()
        },
        // 上拉加载函数
        onLoad: async () => {
          await this.getTaskList(true)
        },
        renderItem: this.renderItem, // 渲染结构
        loadingText: '疯狂加载中',
        finishText: '没啦没啦'
      }).layoutWeight(1)
      // } else {
      //   Column({ space: 20 }) {
      //     Image($r("app.media.ic_not_found"))
      //       .width(200)
      //       .height(120)
      //     Text(`无${this.theStatusOfTheGoods[this.queryParams.status.toString()]}货物`)
      //       .fontColor("#818181")
      //   }
      // }
    }
    .layoutWeight(1)
    // .justifyContent(FlexAlign.Center)
    .backgroundColor("#F4F4F4")

  }
}

export default TaskList