# 保持定时工作流活动

使用这个 GitHub Action，即使最近没有仓库活动也不会禁用定时工作流。

[English](README.md) | 简体中文

## 为什么

在 GitHub 中, 当 60 天没有仓库活动发生时将自动禁用定时工作流。

首先会显示 `This workflow will be disabled soon because there's no recent activity in the repository.` ：

![disabled-soon](https://user-images.githubusercontent.com/62788816/232479889-592e3660-1da4-4eff-aab9-35475d26fc05.png)

## 使用

```yml
name: Keep scheduled workflow activity

on:
  schedule:
    - cron: "0 0 * * *" # 每天 00:00 UTC

jobs:
  keep-scheduled-workflow-activity:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Keep scheduled workflow activity
        uses: WaterLemons2k/scheduled-workflow-activity-action@v1
```

## 输入

所有输入都是可选的。

| 输入      | 描述                                 | 默认                                                    |
| --------- | ----------------------------------- | ------------------------------------------------------- |
| `name`    | 用于 commit 的用户名。               | `github-actions[bot]`                                   |
| `email`   | 用于 commit 的电子邮件地址。         | `41898282+github-actions[bot]@users.noreply.github.com` |
| `message` | 仓库的 commit 消息。                 | `chore: empty commit`                                   |
| `days`    | 最新 commit 和新 commit 之间的天数。 | `50`                                                    |
| `push`    | 是否推送新 commit。                  | `true`                                                  |