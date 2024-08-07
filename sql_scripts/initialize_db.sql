CREATE DATABASE computer_inventory;

USE computer_inventory;


CREATE TABLE Location (
    project_room VARCHAR(100) PRIMARY KEY,  -- 项目室（主键）
    building VARCHAR(100) NOT NULL          -- 楼栋
);

CREATE TABLE PC (
    serial_number VARCHAR(50) PRIMARY KEY,  -- sn码（主键）
    is_rental BOOLEAN,                      -- 是否为租赁
    warranty DATE,                          -- 保修
    notes TEXT,                             -- 备注信息
    project VARCHAR(100),                   -- 项目
    project_room VARCHAR(100),              -- 项目室（外键）
    CONSTRAINT FK_Location FOREIGN KEY (project_room) REFERENCES Location(project_room)
);

CREATE TABLE Employee (
    employee_id VARCHAR(50) PRIMARY KEY,    -- 员工编号（主键）
    name VARCHAR(100) NOT NULL              -- 姓名
);

CREATE TABLE Allocation (
    serial_number VARCHAR(50),              -- sn码
    employee_id VARCHAR(50),                -- 员工编号
    PRIMARY KEY (serial_number, employee_id),
    FOREIGN KEY (serial_number) REFERENCES PC(serial_number),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
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

-- 创建光电园台式机数据视图
CREATE VIEW LJ_PC AS
SELECT
    P.serial_number AS SN码,
    COALESCE(A.employee_id, '空闲') AS 员工号,
    COALESCE(E.name, '空闲') AS 员工姓名,
    P.project AS 项目,
    P.project_room AS 地点,
    P.notes AS 备注,
    P.warranty AS 质保
FROM
    PC P
    LEFT JOIN Allocation A ON P.serial_number = A.serial_number
    LEFT JOIN Employee E ON A.employee_id = E.employee_id
    JOIN Location L ON P.project_room = L.project_room
WHERE
    L.building LIKE '光电园%';

-- 创建光电园台式机数据视图

