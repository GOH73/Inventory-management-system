CREATE DATABASE computer_inventory;

USE computer_inventory;

CREATE TABLE Allocation (
    serial_number VARCHAR(50),              -- sn码
    employee_id VARCHAR(50),                -- 员工编号
    PRIMARY KEY (serial_number, employee_id),
    FOREIGN KEY (serial_number) REFERENCES PC(serial_number),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

CREATE TABLE PC (
    serial_number VARCHAR(50) PRIMARY KEY,  -- sn码（主键）
    is_rental BOOLEAN,                      -- 是否为租赁
    warranty DATE,                          -- 质保
    notes TEXT,                             -- 备注信息
    project VARCHAR(100),                   -- 项目
    project_room VARCHAR(100),              -- 项目室（外键）
    CONSTRAINT FK_Location FOREIGN KEY (project_room) REFERENCES Location(project_room)
);

CREATE TABLE Employee (
    employee_id VARCHAR(50) PRIMARY KEY,    -- 员工编号（主键）
    name VARCHAR(100) NOT NULL              -- 姓名
);

CREATE TABLE Location (
    project_room VARCHAR(100) PRIMARY KEY,  -- 项目室（主键）
    building VARCHAR(100) NOT NULL          -- 楼栋
);


-- 创建总数统计视图
DROP VIEW IF EXISTS PC_Statistics;

CREATE VIEW PC_Statistics AS
SELECT
    L.building AS 楼层,
    L.project_room AS 地点,
    P.project AS 项目,
    COUNT(P.serial_number) AS PC总数,
    COUNT(A.serial_number) AS PC在用数,
    COUNT(P.serial_number) - COUNT(A.serial_number) AS PC空闲数,
    CONCAT(ROUND(100.0 * (COUNT(P.serial_number) - COUNT(A.serial_number)) / COUNT(P.serial_number), 2), '%') AS PC空置率
FROM
    PC P
    LEFT JOIN Allocation A ON P.serial_number = A.serial_number
    JOIN Location L ON P.project_room = L.project_room
GROUP BY
    L.building, L.project_room, P.project;


select * from PC_Statistics;
-- 创建总数统计视图

