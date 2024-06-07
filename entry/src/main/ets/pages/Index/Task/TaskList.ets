import { HmList } from '@hm/basic/Index'
import { getTaskList } from '../../../api'
import { TaskInfoItem, TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import TaskItemCard from './TaskItemCard'

// 待提货
@Component
struct TaskList {
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

  aboutToAppear(): void {
    // 页面创建的时候就刷新一次数据
    this.refreshTheTaskList()
  }

  async getTaskList(append: boolean = true) {
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
    // 请求新的列表数据
    this.queryParams.page = 1 // 重置第一页
    await this.getTaskList(false) // 直接赋值
  }

  @Builder
  renderItem(item: object) {
    TaskItemCard({ taskItemData: item as TaskInfoItemModel })
  }

  build() {
    HmList({
      dataSource: this.taskListData, // 数据源
      finished: this.allPage < this.queryParams.page, // 是否还有下一页
      // 上拉加载的函数
      onLoad: async () => {
        // 上拉加载
        await this.getTaskList()
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

export default TaskList