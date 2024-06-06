import { getTaskList } from '../../../api'
import { TaskInfoItem, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'

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
      AlertDialog.show({ message: JSON.stringify(result, null, 2) })
      this.taskListData = result.items
    } catch (e) {
      console.log("TaskList_e:", JSON.stringify(e))
    }
  }

  build() {
    Text(JSON.stringify(this.taskListData))
  }
}

export default TaskList
