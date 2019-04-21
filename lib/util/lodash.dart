/*
* 仿照 lodash 部分函数实现对应操作
* */

T $_get<T>(Map data, List<String> path, {T defaultData}) {
  if (path.length == 0) {
    throw '[path] should be List<String> not empty!';
  }
  Map curData = data;
  while (path.isNotEmpty) {
    final curPath = path.removeAt(0);
    if (curData != null && curData.containsKey(curPath)) {
      if (path.isEmpty) {
        return curData[curPath];
      } else {
        curData = data[curPath];
      }
    } else {
      return defaultData;
    }
  }
}
