# 椰子的圣诞树 🎄

无广告的圣诞树答题与留言网页。访客完成 11 道题后获得 0–11 分对应的彩球，填写昵称和留言即可挂到树上；主人可以查看并回复留言。

## 发布到 GitHub Pages

1. 在 GitHub 新建一个仓库，例如 `coconut-christmas-tree`。
2. 将本仓库根目录中的文件上传到 GitHub 仓库根目录，确认 `index.html` 直接位于仓库根目录，而不是某个子文件夹中。
3. 打开仓库的 **Settings → Pages**。
4. 在 **Build and deployment → Source** 选择 **Deploy from a branch**。
5. Branch 选择 `main`，目录选择 `/(root)`，保存。
6. 等 GitHub Pages 部署完成后，网址格式为 `https://你的GitHub用户名.github.io/coconut-christmas-tree/`。

官方说明：<https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site>

## 重要：多人留言同步

网页在未连接数据库时会使用当前浏览器的本地存储；朋友之间不会自动共享留言。要让不同手机上的访客都看到同一棵树，并让主人跨设备回复，请配置 Supabase：

1. 在 Supabase 创建项目。
2. 在 SQL Editor 运行本仓库的 `supabase-schema.sql`。运行前将 `OWNER_EMAIL_HERE` 替换为主人登录 Supabase Auth 使用的邮箱。
3. 在 Supabase Auth 中创建主人账号。
4. 在 `index.html` 末尾配置区填写 `SUPABASE_URL`、`SUPABASE_ANON_KEY` 和 `OWNER_EMAIL`。
5. 保存并重新上传 `index.html` 到 GitHub。

**安全提醒：** 前端只能填写 Supabase 的 anon/public key。绝对不要把 `service_role` 密钥、数据库密码或 GitHub Token 写进网页或提交到仓库。

## 项目文件

- `index.html`：网页本体，可直接由 GitHub Pages 托管。
- `supabase-schema.sql`：启用跨设备留言与主人回复时使用的数据库表及访问策略。
