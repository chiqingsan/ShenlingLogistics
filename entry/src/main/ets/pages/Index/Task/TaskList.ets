import { HmList } from '@hm/basic/Index'
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

  @Builder
  getSearchForm() {
    Column() {
      Row() {
        Search({ placeholder: '请输入任务编号' }).backgroundColor($r('app.color.background_page')).height(32)
      }
      .justifyContent(FlexAlign.Center)
      .padding({ left: 15, right: 15, bottom: 5 })

      Row() {
        // 完成搜索页需要测试点击之后键盘和弹层同时弹出的情况
        Button('开始时间')
          .fontSize(14)
          .width(106)
          .height(32)
          .padding({ left: 0, right: 0 })
          .fontColor('#999')
          .backgroundColor($r('app.color.background_page'))

        Text("至")
        Button('结束时间')
          .fontSize(14)
          .width(110)
          .height(32)
          .padding({ left: 0, right: 0 })
          .fontColor('#999')
          .backgroundColor($r('app.color.background_page'))
        Button("筛选")
          .backgroundColor($r('app.color.primary_disabled'))
          .height(32)
          .width(60)
      }.width('100%').alignItems(VerticalAlign.Center).justifyContent(FlexAlign.SpaceAround)
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
  }
}
