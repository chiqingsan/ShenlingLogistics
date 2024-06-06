import { getTaskList } from '../../../api'
import { TaskInfoItem, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import TaskItemCard from './TaskItemCard'

@Preview
@Component
struct TaskList {
  @State queryParams: TaskListParams = new TaskListParamsModel({
    status: TaskTypeEnum.Waiting,
    page: 1,
    pageSize: 5,
  } as TaskListParams)
  @State taskListData: TaskInfoItem[] = []

  aboutToAppear() {
    this.getTaskList()
  }

  async getTaskList() {
    try {
      const result = await getTaskList(this.queryParams)
      this.taskListData = result.items
    } catch (e) {
      console.log("TaskList_e:", JSON.stringify(e))
    }
  }

  build() {
    List() {
      ForEach(
        this.taskListData,
        (item: TaskListParamsModel) => {
          TaskItemCard()
        }
      )
    }
    .scrollBar(BarState.Off)
  }
}

export default TaskList
