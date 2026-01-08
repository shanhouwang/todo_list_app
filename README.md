# todo_list_app

一个用于学习 Flutter 的待办事项示例项目，覆盖了 UI、状态管理、网络请求与分层架构的完整流程，适合初学者阅读与改造。

## 功能概览

- 展示待办列表（支持下拉刷新）
- 新增待办（弹窗表单 + 校验）
- 切换完成状态（本地更新）
- 错误提示与重试

## 技术栈

- Flutter + Material 3
- Riverpod（StateNotifier）状态管理
- http 网络请求
- 简单分层：presentation / domain / data / core

## 目录结构

```
lib/
  app.dart                       # 应用入口配置（主题、首页）
  main.dart                      # Flutter 入口
  core/
    constants/                   # 常量配置
    network/                     # 网络请求封装
    theme/                       # 主题配置
  features/
    todo/
      data/                      # 数据层（模型、数据源、仓库实现）
      domain/                    # 领域层（实体、仓库接口、用例）
      presentation/              # 界面层（页面、组件、状态）
```

## 快速开始

确保已安装 Flutter SDK，并能运行 `flutter doctor`。

```bash
flutter pub get
flutter run
```

## 接口说明

项目使用公开测试接口 `https://jsonplaceholder.typicode.com`：

- `GET /todos?_limit=20`：获取待办列表
- `POST /todos`：创建待办（返回示例数据）

说明：该接口为模拟服务，创建数据不会持久化，仅用于演示流程。

## 运行与检查

```bash
flutter analyze
```

如需构建：

```bash
flutter build apk
```

## 适合继续练习的方向

- 为待办添加“删除/编辑”
- 接入本地存储（如 shared_preferences 或 sqflite）
- 给列表加入筛选与搜索
- 增加更完善的错误/空态设计
