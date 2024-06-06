import { TaskListData, TaskListParams } from '../models'
import { RequestModels } from '@hm/basic'

// 获取任务列表

export const getTaskList = (params: TaskListParams) => {
  return RequestModels.get<TaskListData>("/tasks/list", params)
}