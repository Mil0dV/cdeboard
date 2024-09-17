use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Clone)]
pub struct LeaderboardEntry {
    pub name: String,
    pub climate_impact: f64,
    pub description: String,
}