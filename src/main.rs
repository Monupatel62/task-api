use axum::{extract::State, http::StatusCode, routing::get, Json, Router};
use chrono::{NaiveDate, NaiveDateTime};
use serde::Serialize;
use sqlx::{mysql::MySqlPoolOptions, MySqlPool, Row};
use std::env;

#[derive(Serialize)]
struct Task {
    task_id: i32,
    title: String,
    task: String,
    created_by: String,
    created_on: String,
    due_date: String,
    completed_on: Option<String>,
    status: String,
    assigned_to: String,
}

async fn get_tasks(
    State(pool): State<MySqlPool>,
) -> Result<Json<Vec<Task>>, StatusCode> {
    let rows = sqlx::query(
        r#"
        SELECT
            t.id AS task_id,
            t.title,
            t.description AS task,
            creator.name AS created_by,
            t.created_at,
            t.due_date,
            t.completed_at,
            t.status,
            COALESCE(employee.name, `groups`.name, 'Unassigned') AS assigned_to
        FROM tasks t
        JOIN employees creator
            ON t.created_by = creator.id
        LEFT JOIN employees employee
            ON t.assigned_employee_id = employee.id
        LEFT JOIN `groups`
            ON t.assigned_group_id = `groups`.id
        WHERE t.parent_task_id = 0
        ORDER BY t.id
        "#,
    )
    .fetch_all(&pool)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    let tasks = rows
        .into_iter()
        .map(|row| {
            let created_at: NaiveDateTime = row.get("created_at");
            let due_date: NaiveDate = row.get("due_date");
            let completed_at: Option<NaiveDateTime> = row.get("completed_at");

            Task {
                task_id: row.get("task_id"),
                title: row.get("title"),
                task: row.get("task"),
                created_by: row.get("created_by"),
                created_on: created_at.format("%d-%m-%Y %H:%M:%S").to_string(),
                due_date: due_date.format("%Y-%m-%d").to_string(),
                completed_on: completed_at
                    .map(|date| date.format("%Y-%m-%d %H:%M:%S").to_string()),
                status: row.get("status"),
                assigned_to: row.get("assigned_to"),
            }
        })
        .collect();

    Ok(Json(tasks))
}

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();

    let database_url =
        env::var("DATABASE_URL").expect("DATABASE_URL must be set");

    let pool = MySqlPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await
        .expect("Failed to connect to MySQL");

    let app = Router::new()
        .route("/tasks", get(get_tasks))
        .with_state(pool);

    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000")
        .await
        .expect("Failed to bind port");

    println!("Server running at http://127.0.0.1:3000");

    axum::serve(listener, app)
        .await
        .expect("Server failed");
}