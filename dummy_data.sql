USE task_management;

INSERT INTO employees (id, name) VALUES
(1, 'Amit Sharma'),
(2, 'Rahul Kumar'),
(3, 'Priya Singh'),
(4, 'Vikas Gupta'),
(5, 'Neha Verma');

INSERT INTO `groups` (id, name) VALUES
(1, 'Sales Team'),
(2, 'Development Team');

INSERT INTO tasks
(id, title, description, created_by, created_at, due_date, completed_at, status, parent_task_id, assigned_employee_id, assigned_group_id)
VALUES
(101, 'Follow up with customer', 'Call ABC Industries regarding pending payment', 1, '2026-09-14 10:00:00', '2026-09-16', NULL, 'Pending', 0, 2, NULL),
(102, 'Prepare monthly report', 'Prepare September sales report', 1, '2026-09-15 09:30:00', '2026-09-20', '2026-09-19 16:00:00', 'Completed', 0, NULL, 1),
(103, 'Update website', 'Update company website content', 2, '2026-09-15 11:00:00', '2026-09-22', NULL, 'Pending', 0, 3, NULL),
(104, 'Database backup', 'Take complete database backup', 3, '2026-09-16 10:15:00', '2026-09-18', '2026-09-17 18:00:00', 'Completed', 0, NULL, 2),
(105, 'Client meeting', 'Schedule meeting with XYZ Industries', 1, '2026-09-17 14:00:00', '2026-09-21', NULL, 'Pending', 0, 4, NULL),
(106, 'Code review', 'Review pending backend changes', 2, '2026-09-18 09:00:00', '2026-09-23', NULL, 'Pending', 0, NULL, 2),
(107, 'Sales follow up', 'Follow up with new leads', 4, '2026-09-18 11:30:00', '2026-09-24', NULL, 'Pending', 0, NULL, 1),
(108, 'Documentation', 'Update project documentation', 5, '2026-09-19 15:00:00', '2026-09-25', '2026-09-20 17:00:00', 'Completed', 0, 5, NULL),
(109, 'Send payment reminder', 'Send reminder email to ABC Industries', 1, '2026-09-15 12:00:00', '2026-09-16', NULL, 'Pending', 101, 2, NULL),
(110, 'Review sales figures', 'Review figures before preparing final report', 1, '2026-09-16 13:00:00', '2026-09-19', '2026-09-18 15:30:00', 'Completed', 102, NULL, 1);