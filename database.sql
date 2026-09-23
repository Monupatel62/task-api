CREATE DATABASE IF NOT EXISTS task_management;

USE task_management;

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE `groups` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    created_by INT NOT NULL,
    created_at DATETIME NOT NULL,
    due_date DATE NOT NULL,
    completed_at DATETIME NULL,
    status VARCHAR(50) NOT NULL,
    parent_task_id INT NOT NULL DEFAULT 0,
    assigned_employee_id INT NULL,
    assigned_group_id INT NULL,

    FOREIGN KEY (created_by) REFERENCES employees(id),
    FOREIGN KEY (assigned_employee_id) REFERENCES employees(id),
    FOREIGN KEY (assigned_group_id) REFERENCES `groups`(id)
);