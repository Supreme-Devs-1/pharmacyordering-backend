# Pharmacy Ordering Backend - Database Setup Guide

## Issue
The application was failing with: `Unknown database 'pharmacy'`

## Solution

### Option 1: Auto-Create Database (Recommended for Development)
The `application.properties` has been updated with `createDatabaseIfNotExist=true`, which means:
- The database will be created automatically on first run if it doesn't exist
- Tables will be created via Hibernate's `ddl-auto=update` setting
- Initial data (roles) will be loaded from `data.sql`

**To use this option:**
1. Start your application - it will automatically create the database and tables
2. No manual SQL setup needed!

### Option 2: Manual Database Creation (Recommended for Production)
If the auto-create doesn't work or you prefer manual setup:

1. **Open MySQL Command Line or MySQL Workbench**

2. **Run the setup script:**
   ```bash
   mysql -u root -p < setup/create_database.sql
   ```
   
   OR manually execute the SQL:
   ```sql
   -- Create the pharmacy database
   CREATE DATABASE IF NOT EXISTS pharmacy;
   
   -- Use the pharmacy database
   USE pharmacy;
   
   -- Create tables and insert initial roles
   -- (See setup/create_database.sql for full SQL)
   ```

3. **Verify the database was created:**
   ```sql
   SHOW DATABASES;
   USE pharmacy;
   SHOW TABLES;
   ```

### What Changed in application.properties
- ✅ Added `createDatabaseIfNotExist=true` - auto-creates database
- ✅ Added `allowPublicKeyRetrieval=true` - allows public key authentication
- ✅ Added `useSSL=false&serverTimezone=UTC` - SSL disabled for local dev, timezone set
- ✅ Changed `show-sql=false` - reduces log verbosity (was true)
- ✅ Added explicit `data-locations` and `encoding` for SQL initialization

### Database Credentials
- **Username:** `root` (or from `DB_USERNAME` env var)
- **Password:** `1234` (or from `DB_PASSWORD` env var)
- **Host:** `localhost:3306`
- **Database:** `pharmacy`

### Testing Your Setup
1. Build the project:
   ```bash
   mvn clean install
   ```

2. Start the application:
   ```bash
   mvn spring-boot:run
   ```
   
   Or through your IDE

3. Check the logs for successful database initialization:
   - Look for "CREATE TABLE" statements (Hibernate DDL)
   - Look for role insertion logs
   - Application should start without "Unknown database" errors

4. Verify with a health check:
   ```bash
   curl http://localhost:8080/api/health
   ```

### Troubleshooting
If you still get database errors:

1. **Verify MySQL is running:**
   ```bash
   # Windows
   mysql -u root -p
   
   # Or check if MySQL service is running
   ```

2. **Check connection details:**
   - Verify username/password are correct
   - Verify MySQL port is 3306 (default)
   - Verify hostname is localhost

3. **Manual database creation as fallback:**
   - Run the SQL in `setup/create_database.sql` manually in MySQL Workbench or CLI

4. **Clear application cache:**
   - Delete the `target/` folder
   - Run `mvn clean install`

### Additional Notes
- The `spring.jpa.hibernate.ddl-auto=update` setting will:
  - Create missing tables automatically
  - Add missing columns
  - NOT drop existing tables/columns (safe)
  
- The `spring.sql.init.mode=always` ensures `data.sql` runs on every startup (good for dev)
  - For production, change to `spring.sql.init.mode=never` and manage migrations separately


