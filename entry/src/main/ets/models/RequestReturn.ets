export interface returnsData<T> {
  /**
   * 状态编码：200-成功，非200 -> 失败
   */
  code: string;
  /**
   * 提示信息
   */
  msg: string;
  /*
   * 携带数据
   * */
  data:T
}