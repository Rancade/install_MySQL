#!/bin/bash
# 📜 License: MIT
# 🐱 Author: Rancade
# 🌸 用法: 此脚本仅供参考，请根据实际情况修改脚本内容。
# 脚本名称: install_mysql.sh
# 功能: 自动化安装 MySQL 8.0.26，任何步骤失败即停止
# 用法: sudo ./install_mysql.sh

set -e  # 任何命令返回非零状态立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 检查是否为root用户
#id -u 得到当前用户ID的命令; -ne 0 (0是root)
# exit 1 退出脚本
if [ "$(id -u)" -ne 0 ]; then 
    echo -e "${RED}error: 必须使用root权限运行此脚本${NC}"
    exit 1
fi

# 步骤1: update system packages
# || 前面没有执行运行后面的命令
echo -e "${GREEN}[1/8] uodate...系统包...${NC}"
if command -v apt &>/dev/null; then
     apt update -y || { echo -e "${RED}更新APT失败${NC}"; exit 1; }
elif command -v yum &>/dev/null; then
     yum update -y || { echo -e "${RED}更新YUM失败${NC}"; exit 1; }
else
    echo -e "${RED}不支持的包管理器${NC}"
    exit 1
fi

# 步骤2: 下载MySQL
MYSQL_TAR="mysql-8.0.26-linux-glibc2.12-x86_64.tar"
echo -e "${GREEN}[2/8] 下载MySQL 8.0.26...${NC}"
wget  https://downloads.mysql.com/archives/get/p/23/file/${MYSQL_TAR} -O ${MYSQL_TAR} || {
    echo -e "${RED}下载失败${NC}";
    exit 1;
}

# 步骤3: 验证MD5 (需替换为实际MD5)
MD5sum="084510c174437ee9ec27351bf9945d91"
echo -e "${GREEN}[3/8] 验证MD5...${NC}"
ACTUAL_MD5=$(md5sum ${MYSQL_TAR} | awk '{print $1}')
if [ "$MD5sum" != "$ACTUAL_MD5" ]; then
    echo -e "${RED}MD5校验失败 (期望:${MD5sum} 实际:${ACTUAL_MD5})${NC}"
    exit 1
fi

# 步骤4: 解压文件
echo -e "${GREEN}[4/8] 解压文件...${NC}"
tar -xvf ${MYSQL_TAR} || { echo -e "${RED}解压失败${NC}"; exit 1; }
tar -xvf ${MYSQL_TAR}.xz || { echo -e "${RED}二次解压失败${NC}"; exit 1; }

# 步骤5: 创建安装目录
MYSQL_DIR="/usr/local/mysql/mysql-8.0.26"
echo -e "${GREEN}[5/8] 创建安装目录...${NC}"
mkdir -p ${MYSQL_DIR} || { echo -e "${RED}创建目录失败${NC}"; exit 1; }
mv mysql-8.0.26-linux-glibc2.12-x86_64/* ${MYSQL_DIR} || { echo -e "${RED}移动文件失败${NC}"; exit 1; }

# 步骤6: 安装依赖
echo -e "${GREEN}[6/8] 安装libaio...${NC}"
if command -v apt &>/dev/null; then
    apt install -y libaio1 || { echo -e "${RED}安装libaio失败${NC}"; exit 1; }
elif command -v yum &>/dev/null; then
    yum install -y libaio || { echo -e "${RED}安装libaio失败${NC}"; exit 1; }
fi

# 步骤7: 创建数据目录
echo -e "${GREEN}[7/8] 创建数据目录...${NC}"
mkdir -p ${MYSQL_DIR}/data || { echo -e "${RED}创建数据目录失败${NC}"; exit 1; }

# 步骤8: 设置权限
echo -e "${GREEN}[8/8] 设置权限...${NC}"
groupadd mysql || echo "mysql组已存在"
useradd -r -g mysql mysql || echo "mysql用户已存在"
chown -R mysql:mysql ${MYSQL_DIR} || { echo -e "${RED}权限设置失败${NC}"; exit 1; }
chmod -R 755 ${MYSQL_DIR} || { echo -e "${RED}权限设置失败${NC}"; exit 1; }

echo -e "${GREEN}MySQL 8.0.26 安装准备完成!${NC}"
echo -e "请手动执行以下步骤完成初始化:"
echo -e "1. 初始化数据库:"
echo -e "cd ${MYSQL_DIR} && bin/mysqld --initialize --user=mysql \ --basedir=${MYSQL_DIR} \  --datadir=${MYSQL_DIR}/data"
