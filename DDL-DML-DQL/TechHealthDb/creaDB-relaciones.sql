CREATE DATABASE TechHealthDb; -- 1) crear base
GO

USE TechHealthDb;     --2) establecer base a usar 
GO

SELECT * FROM sys.databases WHERE name = 'TechHealthDb';  --3) ver que hay en la bd  (opcional)
GO

    --4) crear tablas y relaciones entre tablas 
CREATE TABLE [dbo].[Customers] (
    user_id VARCHAR(10) PRIMARY KEY,
    age INT NOT NULL CHECK (age BETWEEN 0 AND 120),  -- Age constraint
    gender CHAR(1) NOT NULL CHECK (gender IN ('M', 'F')), -- Gender constraint
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50),
    country VARCHAR(50) NOT NULL,
    occupation VARCHAR(100),
    income_bracket VARCHAR(20),
    registration_date DATE NOT NULL DEFAULT GETDATE(), -- Default to current date
    subscription_type VARCHAR(50) NOT NULL CHECK (subscription_type IN ('Basic', 'Premium', 'Enterprise')) -- Subscription constraint
);
GO

CREATE TABLE [dbo].[Sales] (
    sale_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10) NOT NULL,
    sale_date DATE NOT NULL DEFAULT GETDATE(),
    product_id VARCHAR(20) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_category VARCHAR(50) NOT NULL CHECK (product_category IN ('Device', 'Accessory', 'Subscription')),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    quantity INT NOT NULL CHECK (quantity > 0),
    discount_applied DECIMAL(5,2) CHECK (discount_applied BETWEEN 0 AND 100),
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('Credit Card', 'PayPal', 'Bank Transfer')),
    subscription_plan VARCHAR(50),
    sales_channel VARCHAR(50) NOT NULL CHECK (sales_channel IN ('Online', 'Retail','Direct Sales')),
    region VARCHAR(50) NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL
);
GO

CREATE TABLE [dbo].[HealthMetrics] (
    record_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10) NOT NULL,
    month_date DATE NOT NULL,
    avg_heart_rate INT NOT NULL CHECK (avg_heart_rate BETWEEN 30 AND 200),
    avg_resting_heart_rate INT NOT NULL CHECK (avg_resting_heart_rate BETWEEN 30 AND 100),
    avg_daily_steps INT NOT NULL CHECK (avg_daily_steps >= 0),
    avg_sleep_hours DECIMAL(3,1) NOT NULL CHECK (avg_sleep_hours BETWEEN 0 AND 24),
    avg_deep_sleep_hours DECIMAL(3,1) NOT NULL CHECK (avg_deep_sleep_hours BETWEEN 0 AND 12),
    avg_daily_calories INT NOT NULL CHECK (avg_daily_calories >= 0),
    avg_exercise_minutes INT NOT NULL CHECK (avg_exercise_minutes >= 0),
    avg_stress_level DECIMAL(3,1) CHECK (avg_stress_level BETWEEN 0 AND 10),
    avg_blood_oxygen DECIMAL(4,1) NOT NULL CHECK (avg_blood_oxygen BETWEEN 80 AND 100),
    total_active_days INT NOT NULL CHECK (total_active_days BETWEEN 0 AND 31),
    workout_frequency INT NOT NULL CHECK (workout_frequency BETWEEN 0 AND 7),
    achievement_rate DECIMAL(3,2) CHECK (achievement_rate BETWEEN 0 AND 1)
);
GO

CREATE TABLE [dbo].[Devices] (
    device_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10) NOT NULL,
    device_type VARCHAR(100) NOT NULL,
    purchase_date DATE NOT NULL DEFAULT GETDATE(),
    last_sync_date DATE NOT NULL,
    firmware_version VARCHAR(10) NOT NULL,
    battery_life_days DECIMAL(3,1) NOT NULL CHECK (battery_life_days >= 0),
    sync_frequency_daily INT NOT NULL CHECK (sync_frequency_daily >= 0),
    active_hours_daily DECIMAL(3,1) NOT NULL CHECK (active_hours_daily BETWEEN 0 AND 24),
    total_steps_recorded BIGINT NOT NULL CHECK (total_steps_recorded >= 0),
    total_workouts_recorded INT NOT NULL CHECK (total_workouts_recorded >= 0),
    sleep_tracking_enabled BIT NOT NULL DEFAULT 0,
    heart_rate_monitoring_enabled BIT NOT NULL DEFAULT 0,
    gps_enabled BIT NOT NULL DEFAULT 0,
    notification_enabled BIT NOT NULL DEFAULT 0,
    device_status VARCHAR(50) NOT NULL CHECK (device_status IN ('Active', 'Inactive', 'Retired'))
);
GO

-- Add table relationships by linking Sales to Customers
ALTER TABLE [dbo].[Sales]
ADD CONSTRAINT FK_Sales_Customers
FOREIGN KEY (user_id) REFERENCES [dbo].[Customers](user_id)
ON DELETE CASCADE ON UPDATE CASCADE;
GO

-- Add table relationships by linking HealthMetrics to Customers
ALTER TABLE [dbo].[HealthMetrics]
ADD CONSTRAINT FK_HealthMetrics_Customers
FOREIGN KEY (user_id) REFERENCES [dbo].[Customers](user_id)
ON DELETE CASCADE ON UPDATE CASCADE;
GO

-- Add table relationships by linking Devices to Customers
ALTER TABLE [dbo].[Devices]
ADD CONSTRAINT FK_Devices_Customers
FOREIGN KEY (user_id) REFERENCES [dbo].[Customers](user_id)
ON DELETE CASCADE ON UPDATE CASCADE;
GO

SELECT name FROM sys.tables;
GO

Exec sp_help 'Customers';
