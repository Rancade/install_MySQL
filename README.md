# 📜 MySQL 自动化安装脚本使用指南

> 这是一份专为 Linux学者（和可爱的技术）准备的脚本说明！(≧▽≦)ﾉ

---

## 🐾 脚本功能
```bash
自动完成以下操作：
1. 系统更新 → 2. 下载 MySQL → 3. MD5 校验 → 4. 解压  
2. 目录准备 → 6. 安装依赖 → 7. 数据目录 → 8. 权限设置
```
## 🎀 使用前准备
### 必备条件
- 🐧 **Linux 系统**（支持 `yum`/`apt`）
    
- ⚡ **root 权限**（小可爱记得加 sudo 哦~）
    
- 🌐 **网络连接**（下载需要 600MB+ 流量）
### 下载脚本
```bash
git clone https://github.com/Rancade/install_MySQL.git
chmod +x install_mysql.sh
```
> 温馨提示：可以用 `wget` 代替 `curl` (｡･ω･｡)

## 🚀 执行方式
### 基础启动
```bash
sudo ./install_mysql.sh
```
### 高级选项

| 命令参数                 | 效果说明           |
| -------------------- | -------------- |
| `-v`                 | 显示详细输出（适合调试）   |
| `--skip-md5`         | 跳过 MD5 校验（不推荐） |
| `--target-dir=/path` | 自定义安装路径        |

---
## 🌈 执行过程示例
```bash
$ sudo ./install_mysql.sh
[1/8] 更新系统包...       ✅ 完成
[2/8] 下载MySQL 8.0.26... 🐾 速度: 5.3MB/s
[3/8] 验证MD5...          🔒 指纹匹配成功！
...
[8/8] 设置权限...         👑 mysql:mysql 权限已设置
```

---
## 🧶 可能遇到的错误
```bash
💔 错误示例 1: 
   "MD5校验失败 (期望:08451... 实际:xxxxx)"
✨ 解决方法：
   - 重新下载文件
   - 或用 --skip-md5 跳过（不安全喵！）

💔 错误示例 2:
   "创建目录失败"
✨ 解决方法：
   - 检查磁盘空间 `df -h`
   - 确认权限 `ls -ld /usr/local`
```

---
## 🍬 安装后小贴士
**1.初始化数据库**：
```bash
cd /usr/local/mysql/mysql-8.0.26
sudo ./bin/mysqld --initialize --user=mysql \
--basedir=/usr/local/mysql/mysql-8.0.26 \
--datadir=/usr/local/mysql/mysql-8.0.26/data
```
> 🌟 会生成临时 root 密码，记得保存
 
**2. 配置 MySQL**
编辑 `/etc/my.cnf`：  这是我的配置
```bash
[mysqld]
basedir=/usr/local/mysql/mysql-8.0.26
datadir=/usr/local/mysql/mysql-8.0.26/data
socket=/usr/local/mysql/mysql-8.0.26/mysql.sock
character-set-server=utf8
port = 3306
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

[client]
socket=/usr/local/mysql/mysql-8.0.26/mysql.sock
default-character-set=utf8
```

**3. 启动服务**：
```bash
sudo cp -a /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
sudo chmod +x /etc/init.d/mysqld
```
添加到系统服务：
```bash
sudo chkconfig --add mysqld
sudo chkconfig mysqld on
```
**4. 环境变量**
```bash
编辑 `/etc/profile` 添加：
export PATH=$PATH:/usr/local/mysql/mysql-8.0.26/bin
```
使配置生效：
```bash
source /etc/profile
```

**5. 启动服务**：
```bash
sudo systemctl start mysqld
```
**6. 连接测试**：
```bash
bin/mysql -u root -p
```
## 🎁 附赠可爱命令
```bash
# 查看安装的MySQL版本（带猫耳特效）
echo "ฅ^•ﻌ•^ฅ MySQL Version:" && ./bin/mysql --version

# 删除安装包（释放空间）
rm -f mysql-8.0.26-linux-glibc2.12-x86_64.tar*
```

>遇到问题可以戳我哦~ (ฅ´ω`ฅ)  
   祝你的 MySQL 顺利跑起来！✨  
   记得常备份数据库~ 🐾
