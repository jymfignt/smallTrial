# 简易PDF图片可视化图库生成器

![License](https://img.shields.io/badge/License-MIT-green)      ![Platform](https://img.shields.io/badge/Platform-Windows-blue) 


PDF图片提取与可视化浏览，支持Obsidian集成。完全本地化运行，无需联网。

---

## 🌟 功能特性
- **一键提取**：命令行批量提取PDF图片
- **智能索引**：自动生成带元数据的Markdown索引
- **跨平台**：支持Windows
- **隐私保护**：所有操作均在本地完成

---

## 🛠️ 环境配置

### 必需工具
| 工具            | 作用    | 验证命令                            |
| ------------- | ----- | ------------------------------- |
| Poppler-utils | PDF解析 | `pdfimages -v`                  |
| R 4.0+        | 脚本执行  | `R --version`                   |
| stringr包      | 文本处理  | `Rscript -e "library(stringr)"` |
| obisidian     | 浏览图片  |                                 |

---

## 📖 使用指南

### 第一步：安装需要插件和软件

### 第二步：提取PDF图片
```
# 创建项目文件夹
mkdir pdf-gallery

# 检查版本（注意参数是 -v 不是 - v）
pdfimages -v

# 正确输出示例：
# pdfimages version 24.08.0
# Copyright 2005-2024 The Poppler Developers - http://poppler.freedesktop.org
# Copyright 1996-2011, 2022 Glyph & Cog, LLC

# 基本用法
pdfimages -png input.pdf images
# 生成图片均为images前缀

# 指定页码（提取1-3页）
pdfimages -f 1 -l 3 -png input.pdf images
```
### 第三步：生成索引文件

1. 创建 `generate_index.R` 文件并粘贴以下代码：
```
library(stringr)
files <- list.files(pattern = ".*-\\d{3}\\.png$")
page_numbers <- as.numeric(str_extract(files, "\\d{3}")) %/% 10 + 1
md_content <- "# PDF图片图库\n\n"
current_page <- 0
for (i in seq_along(files)) {
  if (page_numbers[i] != current_page) {
    md_content <- paste0(md_content, "\n## 第", page_numbers[i], "页\n")
    current_page <- page_numbers[i]
  }
  md_content <- paste0(md_content, "![[", files[i], "]]\n")
}
writeLines(md_content, "Gallery.md")
# 提示完成
cat("索引文件已生成：Gallery.md\n")
```
2. 运行脚本：
```
# 切换到R文件所在目录
Rscript generate_index.R
```
### 第四步：打开obisidian打开生成的`Gallery.md`
>可搭配*Image Gallery* 插件使用

---
## 项目结构
```
/pdf-gallery
├── input.pdf            # 源PDF文件
├── generate_index.R     # 索引生成脚本
├── Gallery.md           # 自动生成的索引
├── images-000.png       # 提取的图片
├── ...                  
└── README.md
```

---

## ⚠️ 高危操作预警

### 关键注意事项

1. **路径规范**
    
    - 禁止使用中文路径：`错误：D:\PDF项目\测试`
        
    - 推荐短路径格式：`D:\pdf_project`
        
2. **文件覆盖风险**
    
   ```
    # 危险操作：重复使用相同输出前缀
    pdfimages -png input.pdf output  # 可能覆盖已有文件
    ```
3. **系统权限**
    
    - 需以管理员身份运行PowerShell执行环境变量配置

---

## 🚨 故障排查

### 常见问题解决方案

| 错误类型         | 应急措施                                                                                         | 根治方案         |
| ------------ | -------------------------------------------------------------------------------------------- | ------------ |
| `Rscript未找到` | 使用绝对路径：  <br>`"C:\Program Files\R\bin\Rscript.exe" generate_index.R`                         | 检查环境变量PATH配置 |
| `stringr包缺失` | 手动安装：  <br>`install.packages("stringr", repos="https://mirrors.tuna.tsinghua.edu.cn/CRAN/")` | 配置镜像源        |
| 图片顺序错乱       | 添加排序参数：  <br>`pdfimages -p -png input.pdf images`                                            | 检查PDF内部结构    |
>**操作提示**：首次使用建议在测试PDF上验证流程，确认无误后再处理重要文档。
