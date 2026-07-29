# 🗄️ Railway MySQL Database Setup & Import Guide

This guide walks you through importing the `QuizPro` database schema and seed questions (`sql/01_create_schema_and_seed.sql`) into your **Railway MySQL** instance.

---

## 🔑 1. Obtain your Railway MySQL Credentials
Log into your [Railway Dashboard](https://railway.app/), navigate to your MySQL service, and open the **Connect** or **Variables** tab to find:
- **`MYSQLHOST`** (e.g., `autorack.proxy.rlwy.net` or `mysql.railway.internal`)
- **`MYSQLPORT`** (e.g., `3306` or assigned proxy port like `14832`)
- **`MYSQLUSER`** (usually `root`)
- **`MYSQLPASSWORD`** (your generated Railway password)
- **`MYSQLDATABASE`** (usually `railway` or `quizdb`)

---

## 🛠️ Option A: Automated Script Import (Recommended)

### On Windows
Run the interactive batch script:
```cmd
.\import.bat
```
*The script will prompt for your Railway Host, Password, Port, Database, and User, then automatically execute the SQL seed script.*

### On Linux / macOS
Make the shell script executable and run it:
```bash
chmod +x import.sh
./import.sh
```

---

## 💻 Option B: MySQL Command Line (CLI)

Open your terminal or command prompt and run the following command (substituting your Railway details):

```bash
mysql -h <MYSQLHOST> -P <MYSQLPORT> -u <MYSQLUSER> -p<MYSQLPASSWORD> <MYSQLDATABASE> < sql/01_create_schema_and_seed.sql
```

**Example:**
```bash
mysql -h autorack.proxy.rlwy.net -P 14832 -u root -pMySecretPassword railway < sql/01_create_schema_and_seed.sql
```

---

## 🎨 Option C: MySQL Workbench

1. Open **MySQL Workbench**.
2. Click **+** to add a new connection:
   - **Connection Name**: `Railway MySQL`
   - **Hostname**: `<MYSQLHOST>` (e.g., `autorack.proxy.rlwy.net`)
   - **Port**: `<MYSQLPORT>` (e.g., `14832`)
   - **Username**: `<MYSQLUSER>` (e.g., `root`)
   - **Password**: Click *Store in Vault...* and enter `<MYSQLPASSWORD>`.
3. Click **Test Connection** → **OK**.
4. Double-click the connection to open the query tab.
5. Go to **File** → **Open SQL Script...** and select `sql/01_create_schema_and_seed.sql`.
6. Execute the script by clicking the **⚡ Lightning Bolt** button.

---

## ✅ Verification
Once imported, verify that the following tables exist in your Railway database:
- `users`
- `questions` (with 60 seed questions)
- `results`

Your database is now fully prepared for Render deployment!
