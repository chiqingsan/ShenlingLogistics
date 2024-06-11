import { HmList, HmLoading, HmNoting } from '@hm/basic/Index'
import { getTaskList } from '../../../api'
import { TaskInfoItem, TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import TaskItemCard from './TaskItemCard'

// 待提货
@Component
export struct TaskList {
  @Prop index: number = 0
  @State
  queryParams: TaskListParamsModel = new TaskListParamsModel(
    {
      status: TaskTypeEnum.Waiting, // 待提货的类型
      page: 1, // 第几页
      pageSize: 5 // 每页几条数据
    } as TaskListParams
  )
  @State
  taskListData: TaskInfoItem[] = []
  @State
  allPage: number = 1 // 默认只有一页
  @State
  reset: boolean = false // 用于控制重置状态
  loading: CustomDialogController = new CustomDialogController({
    builder: HmLoading({
      title: '搜索查询中'
    }),
    customStyle: true,
    autoCancel: false,
    alignment: DialogAlignment.Center
  })

  async getTaskList(append: boolean) {
    const result = await getTaskList(this.queryParams)
    if (append) {
      this.taskListData.push(...result.items || [])
    } else {
      this.taskListData = result.items
    }

    this.allPage = result.pages
    this.queryParams.page++
  }

  async refreshTheTaskList() {
    // 重置页数为1
    this.queryParams.page = 1
    await this.getTaskList(false) // 直接赋值
  }

  // 日期补零
  addZero(value: number) {
    return value.toString().padStart(2, "0")
  }

  // 控制筛选按钮可点
  getSearchEnable() {
    return this.queryParams.startTime && this.queryParams.endTime ? true : false
  }

  // 获取没有货物时的文本
  getNothingText() {
    if (this.queryParams.status === TaskTypeEnum.Waiting) {
      return "无待提货物"
    } else if (this.queryParams.status === TaskTypeEnum.Line) {
      return "无在途任务"
    } else {
      return "无完成任务"
    }
  }

  @Builder
  getSearchForm() {
    Column() {
      Row() {
        Search({ placeholder: '请输入任务编号', value: this.queryParams.transportTaskId || '' })
          .backgroundColor($r('app.color.background_page'))
          .height(32)
          .onSubmit(async value => {
            this.loading.open()
            this.queryParams.page = 1
            if (value) {
              this.queryParams.startTime = ''
              this.queryParams.endTime = ''
              this.reset = false
              this.allPage = 0 // 有值意味着只有一条 因为是根据单号传的，所以不让它继续往后查 否则会重复
              this.queryParams.transportTaskId = isNaN(parseInt(value)) ? "0" : value
            } else {
              this.allPage = 1 // 没值意味着查不到 重新加载
              this.queryParams.transportTaskId = ""
            }
            const result = await getTaskList(this.queryParams)
            this.taskListData = result.items || []
            this.loading.close()
          })
      }
      .justifyContent(FlexAlign.Center)
      .padding({ left: 15, right: 15, bottom: 5 })

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
                this.queryParams.endTime = `${value.year}-${this.addZero(value.month! + 1)}-${this.addZero(value.day)}`
              }
            })
          })
        Button(this.reset ? "重置" : "筛选")
          .backgroundColor(this.getSearchEnable() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .height(32)
          .width(60)
          .enabled(this.getSearchEnable())
          .onClick(async () => {
            if (this.reset) {
              this.queryParams.startTime = ''
              this.queryParams.endTime = ''
              this.reset = false
            } else {
              this.reset = true
            }
            this.loading.open()
            this.allPage = 1
            this.queryParams.page = 1
            await this.getTaskList(false)
            this.loading.close()
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceAround)
      .padding({ left: 15, right: 15 })
    }
    .backgroundColor($r('app.color.white'))
    .padding({
      right: 15,
      left: 15,
      bottom: 15,
    })
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }

  @Builder
  renderItem(item: object) {
    TaskItemCard({ taskItemData: item as TaskInfoItemModel })
  }

  build() {
    Column() {
      if (this.queryParams.status === TaskTypeEnum.Finish) {
        this.getSearchForm()
      }
      HmList({
        dataSource: this.taskListData, // 数据源
        finished: this.allPage < this.queryParams.page, // 是否还有下一页
        // 上拉加载的函数
        onLoad: async () => {
          // 上拉加载
          await this.getTaskList(true)
        },
        renderItem: this.renderItem,
        onRefresh: async () => {
          await this.refreshTheTaskList()
        },
        loadingText: '拼命加载中',
        finishText: '没啦没啦'
      })

    }
    .width("100%")
    .height("100%")
  }
}
