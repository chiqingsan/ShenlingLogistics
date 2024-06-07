export const DateFormat = (value: Date) => {
  // 2023-12-23 05:12
  const enterTime = value.toJSON()
    .split(".")[0]
    .split("T")
    .map(v => {
      return v.includes(":") ? v.slice(0, v.lastIndexOf(':')) : v
    })
    .join(" ")
  return enterTime
}