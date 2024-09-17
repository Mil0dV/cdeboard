use actix_cors::Cors;
use actix_web::{web, App, HttpServer, Responder};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
struct LeaderboardEntry {
    name: String,
    climate_impact: f64,
    description: String,
}

async fn get_leaderboard() -> impl Responder {
    let entries = vec![
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
    ];
    web::Json(entries)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .wrap(
                Cors::default()
                    .allow_any_origin()
                    .allow_any_method()
                    .allow_any_header()
            )
            .route("/leaderboard", web::get().to(get_leaderboard))
    })
    .bind("127.0.0.1:8081")?
    .run()
    .await
}