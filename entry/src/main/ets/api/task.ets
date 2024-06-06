import { TaskListData, TaskListParams } from '../models'
import { RequestModels } from '@hm/basic'
import { TaskDetailInfoModel } from '../models'


// 获取任务列表
export const getTaskList = (params: TaskListParams) => {
  return RequestModels.get<TaskListData>("/tasks/list", params)
}

// 获取任务列表
export const getTaskDetail = (id: string) => {
  return RequestModels.get<TaskDetailInfoModel>(`/tasks/details/${id}`)
}