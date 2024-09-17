use std::sync::Mutex; // Add this import
use actix_cors::Cors;
use actix_web::{web, App, HttpServer, Responder, HttpResponse, post, get}; // Add `HttpResponse`, `post`, and `get`

use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Clone, Debug)] // Add Debug here
struct LeaderboardEntry {
    name: String,
    climate_impact: f64,
    description: String,
}

// Shared state type
type Db = Mutex<Vec<LeaderboardEntry>>;

// Update get_leaderboard to use shared state
#[get("/leaderboard")]
async fn get_leaderboard(data: web::Data<Db>) -> impl Responder {
    let entries = data.lock().unwrap();
    web::Json(entries.clone())
}

// Add handler to add new leaderboard entry
#[post("/leaderboard")]
async fn add_leaderboard_entry(entry: web::Json<LeaderboardEntry>, data: web::Data<Db>) -> impl Responder {
    let mut entries = data.lock().unwrap();
    println!("Adding new entry: {:?}", entry); // Add this line for logging
    entries.push(entry.into_inner());
    HttpResponse::Created().finish()
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let leaderboard_data = web::Data::new(Mutex::new(vec![
        LeaderboardEntry {
            name: "Alice".to_string(),
            climate_impact: 10.5,
            description: "Environmental activist".to_string(),
        },
        LeaderboardEntry {
            name: "Bob".to_string(),
            climate_impact: 8.3,
            description: "Sustainable farmer".to_string(),
        },
    ]));

    HttpServer::new(move || {
        App::new()
            .app_data(leaderboard_data.clone())
            .wrap(
                Cors::default()
                    .allow_any_origin()
                    .allow_any_method()
                    .allow_any_header()
            )
            .service(get_leaderboard)
            .service(add_leaderboard_entry) // Register the new service
    })
    .bind("127.0.0.1:8081")?
    .run()
    .await
}