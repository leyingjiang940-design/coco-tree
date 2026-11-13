# 上传到 GitHub（网页操作）

1. 登录 GitHub，点击 New repository。
2. Repository name 填 `coconut-christmas-tree`。
3. 为了让朋友无需登录即可访问网页，仓库可设为 Public；这表示网页源代码也会公开。若不希望公开源代码，先不要创建 Public 仓库。
4. 创建仓库后，点 `Add file` → `Upload files`。
5. 将本目录中的 `index.html`、`README.md`、`supabase-schema.sql` 上传到仓库根目录，然后 Commit changes。
6. 进入 `Settings` → `Pages`，Source 选择 `Deploy from a branch`，Branch 选 `main`，文件夹选 `/(root)`，保存。
7. 等待 Pages 发布完成；GitHub 会在 Pages 页面显示站点地址。

注意：请上传文件本身，不要把外层文件夹 `coconut-christmas-tree-github` 再套进仓库。`index.html` 必须在仓库根目录，地址才会直接打开主页。
