# Task Management API

A simple Task Management REST API built with Rust, Axum, SQLx, and MySQL.

## Tech Stack

- Rust
- Axum
- SQLx
- MySQL
- Tokio
- Serde
- Chrono

## Project Structure

```text
task-api/
├── src/
│   └── main.rs
├── database.sql
├── dummy_data.sql
├── .gitignore
├── Cargo.toml
└── README.md
```

> `.env` is created locally and is not included in GitHub because it contains database credentials.

## Database Design

The project uses three tables:

### Employees

Stores employee information.

- `id`
- `name`

### Groups

Stores group information.

- `id`
- `name`

### Tasks

Stores task information.

- `id`
- `title`
- `description`
- `created_by`
- `created_at`
- `due_date`
- `completed_at`
- `status`
- `parent_task_id`
- `assigned_employee_id`
- `assigned_group_id`

### Relationships

- `created_by` references `employees.id`
- `assigned_employee_id` references `employees.id`
- `assigned_group_id` references `groups.id`

A task can be assigned to either an employee or a group.

`parent_task_id = 0` represents a main/parent task.

A non-zero `parent_task_id` represents a child/sub-task.

## Requirements

Install:

- Rust
- Cargo
- MySQL

Check Rust installation:

```bash
rustc --version
cargo --version
```

## Setup and Run

Follow the steps in this order.

### 1. Start MySQL

Make sure the MySQL server is running.

### 2. Create Database and Tables

Open a terminal in the project directory and run:

```bash
mysql -u root -p < database.sql
```

This automatically creates:

- `task_management` database
- `employees` table
- `groups` table
- `tasks` table

No manual database or table creation is required.

### 3. Insert Dummy Data

Run:

```bash
mysql -u root -p < dummy_data.sql
```

This inserts:

- 5 employees
- 2 groups
- 10 tasks
- Employee assignments
- Group assignments
- Completed tasks
- Pending tasks
- Child/sub-tasks

### 4. Create `.env`

Create a `.env` file in the project root.

PowerShell:

```powershell
New-Item .env -ItemType File
```

Then add the following:

```env
DATABASE_URL=mysql://root:YOUR_PASSWORD@localhost:3306/task_management
```

Replace `YOUR_PASSWORD` with your local MySQL password.

Example:

```env
DATABASE_URL=mysql://root:MyPassword@localhost:3306/task_management
```

Do not commit the `.env` file to GitHub.

### 5. Run the API

From the project directory, run:

```bash
cargo run
```

The server will start at:

```text
http://127.0.0.1:3000
```

## API Endpoint

### Get All Main Tasks

```http
GET /tasks
```

Open:

```text
http://127.0.0.1:3000/tasks
```

The API returns only main/parent tasks.

The SQL query uses:

```sql
WHERE t.parent_task_id = 0
```

Therefore, child tasks are excluded from the response.

## Sample Response

```json
[
  {
    "task_id": 101,
    "title": "Follow up with customer",
    "task": "Call ABC Industries regarding pending payment",
    "created_by": "Amit Sharma",
    "created_on": "14-09-2026 10:00:00",
    "due_date": "2026-09-16",
    "completed_on": null,
    "status": "Pending",
    "assigned_to": "Rahul Kumar"
  }
]
```

## How the API Fetches Data

The API uses SQL JOINs to fetch related information.

- Task details come from the `tasks` table.
- Creator name comes from the `employees` table.
- Assigned employee name comes from the `employees` table.
- Assigned group name comes from the `groups` table.

`COALESCE` is used to return the assigned employee name, group name, or `Unassigned`.

The query filters `parent_task_id = 0` so that only main/parent tasks are returned.

## Project Flow

```text
MySQL Database
      ↓
Database Tables
      ↓
Dummy Data
      ↓
SQL JOIN Query
      ↓
Rust + SQLx
      ↓
Axum API
      ↓
JSON Response
```

## Testing

After starting the API, open:

```text
http://127.0.0.1:3000/tasks
```

Or use:

```bash
curl http://127.0.0.1:3000/tasks
```

## Notes

- No frontend is required.
- Database credentials are not hard-coded in the Rust source code.
- `.env` is excluded from Git using `.gitignore`.
- `database.sql` creates the database and tables.
- `dummy_data.sql` inserts the required dummy data.
- The project can be run locally after completing the setup steps above.