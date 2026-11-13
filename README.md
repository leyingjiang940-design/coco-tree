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

## 云端留言与主人登录

本仓库已连接 Supabase 项目。朋友的留言会保存到共享数据库并通过 Realtime 同步；未配置主人邮箱前，主人回复入口仍保持锁定。

### 绑定椰子主人账号

1. 先确定椰子专用的登录邮箱。
2. 在 Supabase Dashboard 的 **Authentication → URL Configuration** 中，把 Site URL 设为 `https://leyingjiang940-design.github.io/coco-tree/`，并把同一地址加入 Redirect URLs。
3. 将 `index.html` 中 `OWNER_EMAIL` 设置为椰子的登录邮箱。
4. 在本仓库根目录的 `supabase-schema.sql` 最后执行 owner email 更新语句，把 `OWNER_EMAIL_HERE` 替换为相同邮箱：
   `update private.tree_owner set owner_email = lower('OWNER_EMAIL_HERE') where singleton = true;`
5. 提交更新。打开网页右上/主人入口，首次用绑定邮箱创建账号，按邮件完成验证，再用邮箱和新密码登录。

**密码安全：** 密码由 Supabase Auth 安全校验，不写入 `index.html`、SQL 或 GitHub。由于密码曾在聊天中发送，请为正式账户另设一个新密码。前端只放 Supabase publishable key；绝不可提交 `service_role` 或 `sb_secret_...` 密钥。

## 项目文件

- `index.html`：网页本体，可直接由 GitHub Pages 托管。
- `supabase-schema.sql`：启用跨设备留言与主人回复时使用的数据库表及访问策略。
