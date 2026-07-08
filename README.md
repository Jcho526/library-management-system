# 图书管理系统

Spring Boot + MyBatis + MySQL 图书管理系统，支持管理员后台管理、读者借阅、AI 智能摘要与客服问答。

## 技术栈

| 层级 | 技术 |
|------|------|
| 后端 | Spring Boot 3.2.5, Java 21, MyBatis 3 |
| 数据库 | MySQL 8.0+ |
| 前端 | 原生 HTML/CSS/JS + ECharts |
| AI | DeepSeek API（兼容 OpenAI 接口） |

## 快速启动

### 1. 环境准备

- **JDK 21**（必须）
- **Maven 3.6+**
- **MySQL 8.0+** 已启动且可连接

### 2. 配置数据库

用项目中的建库脚本初始化：

```bash
mysql -u root -p < SQL/script.sql
```

如果用上面的命令报编码错误，先确认文件是 UTF-8 编码后重试。

### 3. 填写配置

```bash
cp .env.example .env
```

编辑 `.env`，填入你的实际值：

```env
DB_PASSWORD=你的MySQL密码
DEEPSEEK_API_KEY=你的DeepSeek_API_Key
```

如果不需要 AI 功能，`DEEPSEEK_API_KEY` 可以留空，AI 接口会返回错误但不影响其他功能。

### 4. 启动项目

```bash
source .env && mvn spring-boot:run
```

启动成功后访问：

| 地址 | 说明 |
|------|------|
| http://localhost:8080 | 登录页面 |
| http://localhost:8080/management.html | 管理员端 |
| http://localhost:8080/reader.html | 读者端 |

### 5. 登录测试账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | `admin` | `admin123` |
| 读者 | `reader` | `reader123` |

## Docker 部署（推荐）

本地开发可以不用 Docker，直接 `mvn spring-boot:run` 就行。部署到云服务器用 Docker 最方便。

### 本地构建

```bash
# 构建并启动（MySQL + 应用一起）
docker compose up -d --build
```

首次启动会自动执行 `database/library_db.sql` 初始化数据库。访问 http://localhost:8080。

### 部署到云服务器

```bash
# 1. 在服务器上装好 Docker 和 Docker Compose

# 2. 把项目传上去（只传源码，不用传 target）
scp -r . user@你的服务器IP:/opt/library-management/

# 3. SSH 到服务器
ssh user@你的服务器IP

# 4. 进入项目目录
cd /opt/library-management

# 5. 设置环境变量（密码和 API Key）
export DB_PASSWORD=你的数据库密码
export DEEPSEEK_API_KEY=你的AI_Key   # 不用 AI 可跳过

# 6. 构建并启动
docker compose up -d --build

# 7. 查看日志确认启动成功
docker compose logs -f app
```

启动后访问 `http://服务器IP:8080`。

### 常用命令

```bash
docker compose up -d          # 后台启动
docker compose down           # 停止并删除容器
docker compose restart app    # 重启应用
docker compose logs -f app    # 查看应用日志
docker compose ps             # 查看运行状态
```

### 环境变量

启动时通过 `export` 或写 `.env` 文件传入：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `DB_PASSWORD` | MySQL root 密码 | `library123` |
| `DEEPSEEK_API_KEY` | DeepSeek API Key | 空（不启用 AI） |

```bash
# 或者用 .env 文件
echo 'DB_PASSWORD=我的密码' > .env
echo 'DEEPSEEK_API_KEY=sk-xxx' >> .env
docker compose up -d --build
```

## 项目结构

```
src/
├── main/java/com/example/library/
│   ├── controller/     # 接口层
│   ├── service/        # 业务层
│   ├── mapper/         # MyBatis 数据访问
│   ├── entity/         # 实体类
│   └── config/         # 配置类
├── main/resources/
│   ├── application.yml        # 主配置（环境变量占位）
│   ├── application-local.yml  # 本地覆盖配置（不提交 Git）
│   ├── mapper/                # MyBatis SQL XML
│   └── static/                # 前端页面
├── SQL/script.sql             # 数据库建库脚本
├── database/library_db.sql    # 完整数据导出（含测试数据）
├── .env.example               # 环境变量模板
└── pom.xml
```

## 功能模块

### 管理员端

- 全部图书记录（增删改查 + AI 摘要生成 + 封面上传）
- 详情分类浏览
- 借阅记录管理
- **读者管理**（查看注册读者信息及借阅历史）

### 读者端

- 可视化数据大屏（真实借阅统计 + ECharts 图表）
- 热门图书封面轮播
- 个人信息管理 + 头像上传
- 图书查询 + 详情页 + 借阅
- **AI 智能客服助手**（右下角悬浮窗）

## 打包部署

```bash
# 打包为 jar
source .env && mvn clean package -DskipTests

# 运行
java -jar target/library-management-1.0.0.jar
```

## 配置说明

敏感信息通过环境变量或 Spring Boot Profile 注入，不硬编码：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `DB_URL` | MySQL 连接串 | `jdbc:mysql://localhost:3306/library_db...` |
| `DB_USERNAME` | 数据库用户名 | `root` |
| `DB_PASSWORD` | 数据库密码 | 空 |
| `DEEPSEEK_API_KEY` | DeepSeek API Key | 空 |
| `SERVER_PORT` | 服务端口 | `8080` |

三种注入方式任选：

```bash
# 方式 A：环境变量文件
source .env && mvn spring-boot:run

# 方式 B：Spring Boot Profile
mvn spring-boot:run -Dspring-boot.run.profiles=local

# 方式 C：命令行传参
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.datasource.password=xxx --deepseek.api.key=sk-xxx"
```
