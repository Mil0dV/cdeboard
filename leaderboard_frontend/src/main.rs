mod models;

use yew::prelude::*;
use gloo_net::http::Request;
use wasm_bindgen_futures::spawn_local;
use models::LeaderboardEntry;

#[function_component(App)]
fn app() -> Html {
    let entries = use_state(Vec::new);
    let loading = use_state(|| true);

    {
        let entries = entries.clone();
        let loading = loading.clone();
        use_effect_with_deps(move |_| {
            spawn_local(async move {
                let fetched_entries: Vec<LeaderboardEntry> = Request::get("http://127.0.0.1:8081/leaderboard")
                    .send()
                    .await
                    .unwrap()
                    .json()
                    .await
                    .unwrap();
                entries.set(fetched_entries);
                loading.set(false);
            });
            || ()
        }, ());
    }

    html! {
        <>
            <h1 class="page-header">{ "Climate Action Leaderboard" }</h1>
            if *loading {
                <p>{ "Loading..." }</p>
            } else {
                <table class="leaderboard-table">
                    <thead>
                        <tr>
                            <th>{ "Name" }</th>
                            <th>{ "Climate Impact (Gtonne CO2e)" }</th>
                            <th>{ "Description" }</th>
                        </tr>
                    </thead>
                    <tbody>
                        { for entries.iter().map(|entry| html! {
                            <tr class="leaderboard-item">
                                <td class="entry-name">{ &entry.name }</td>
                                <td class="entry-impact">{ format!("{}", entry.climate_impact) }</td>
                                <td class="entry-description">{ &entry.description }</td>
                            </tr>
                        }) }
                    </tbody>
                </table>
            }
        </>
    }
}

fn main() {
    yew::Renderer::<App>::new().render();
}