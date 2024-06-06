import { HmList } from '@hm/basic/Index'
import { getTaskList } from '../../../api'
import { TaskInfoItem, TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import TaskItemCard from './TaskItemCard'

// 待提货
@Component
struct TaskList {
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

  async getTaskList() {
    const result = await getTaskList(this.queryParams)
    // 追加数据
    // this.taskListData = this.taskListData.concat(result.items) // 拿到返回的数组
    this.taskListData.push(...result.items) // 延展运算符的写法
    this.allPage = result.pages // 总页数
    this.queryParams.page++ // 下次请求的页码
  }

  async refreshTheTaskList() {
    // 重置页数为1
    this.queryParams.page = 1
    // 请求新的列表数据
    const result = await getTaskList(this.queryParams)
    this.taskListData = result.items
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