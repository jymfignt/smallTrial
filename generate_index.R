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
