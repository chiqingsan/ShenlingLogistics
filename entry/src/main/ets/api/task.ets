import { CarRecordTypeModel, DeliverParamsTypeModel, PickUpParamsModel, TaskListData, TaskListParams } from '../models'
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

// 提货
export const pickUp = (data: PickUpParamsModel) => {
  return RequestModels.post<null>("/tasks/takeDelivery", data)
}

// 交货
export const deliver = (data: DeliverParamsTypeModel) => {
  return RequestModels.post<null>("/tasks/deliver", data)
}

// 交车
export const carRecord = (data: CarRecordTypeModel) => {
  return RequestModels.post<null>("/tasks/truckRegistration", data)
}