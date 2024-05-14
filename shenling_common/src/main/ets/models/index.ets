export * from './advert'
export * from './basic_datasource'
export * from './common'

// 统一的类型工具 用来处理所有的接口的返回类型
export class ResponsesData<T> {
  code: number = 0
  msg: string = ""
  data: T | null = null
}