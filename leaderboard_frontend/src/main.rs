mod models;

use yew::prelude::*;
use gloo_net::http::Request;
use wasm_bindgen_futures::spawn_local;
use web_sys::HtmlInputElement; // Correct Import
use models::LeaderboardEntry;
use std::rc::Rc;
use std::cell::RefCell; // Add this line

#[function_component(App)]
fn app() -> Html {
    let entries = use_state(|| Rc::new(RefCell::new(Vec::new())));
    let loading = use_state(|| true);
    let show_form = use_state(|| false);
    let name = use_state(|| "".to_string());
    let impact = use_state(|| "".to_string());
    let description = use_state(|| "".to_string());
    let error = use_state(|| None::<String>); // Add a new state for error messages

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
                entries.borrow_mut().clear(); // Clear the vector
                entries.borrow_mut().extend(fetched_entries); // Extend with new entries
                loading.set(false);
            });
            || ()
        }, ());
    }

    // Toggle form visibility
    let toggle_form = {
        let show_form = show_form.clone();
        Callback::from(move |_| show_form.set(!*show_form))
    };

    // Handlers for form inputs
    let on_name_change = {
        let name = name.clone();
        Callback::from(move |e: InputEvent| {
            let input: HtmlInputElement = e.target_unchecked_into();
            name.set(input.value());
        })
    };

    let on_impact_change = {
        let impact = impact.clone();
        Callback::from(move |e: InputEvent| {
            let input: HtmlInputElement = e.target_unchecked_into();
            impact.set(input.value());
        })
    };

    let on_description_change = {
        let description = description.clone();
        Callback::from(move |e: InputEvent| {
            let input: HtmlInputElement = e.target_unchecked_into();
            description.set(input.value());
        })
    };

    // Handler for form submission
    let on_submit = {
        let entries = entries.clone();
        let loading = loading.clone();
        let show_form = show_form.clone();
        let error = error.clone();
        let name = name.clone();
        let impact = impact.clone();
        let description = description.clone();

        Callback::from(move |e: SubmitEvent| {
            e.prevent_default();
            let entries = entries.clone();
            let loading = loading.clone();
            let show_form = show_form.clone();
            let error = error.clone();

            let new_entry = LeaderboardEntry {
                name: (*name).clone(),
                climate_impact: (*impact).parse().unwrap_or(0.0),
                description: (*description).clone(),
            };

            spawn_local(async move {
                handle_submit(new_entry, entries, loading, show_form, error).await;
            });
        })
    };

    html! {
        <>
            <h1 class="page-header">{ "Climate Action Leaderboard" }</h1>
            <button onclick={toggle_form}>{ "Add Entry" }</button>
            { if *show_form {
                html! {
                    <form onsubmit={on_submit}>
                        <input type="text" placeholder="Name" value={(*name).clone()} oninput={on_name_change} required={true} />
                        <input type="number" placeholder="Climate Impact" value={(*impact).clone()} oninput={on_impact_change} required={true} />
                        <textarea placeholder="Description" value={(*description).clone()} oninput={on_description_change} required={true}></textarea>
                        <button type="submit">{ "Submit" }</button>
                    </form>
                }
            } else {
                html! {}
            }}
            { if let Some(err) = &*error {
                html! { <p class="error">{ err }</p> }
            } else {
                html! {}
            }}
            { if *loading {
                html! { <p>{ "Loading..." }</p> }
            } else {
                html! {
                    <table class="leaderboard-table">
                        <thead>
                            <tr>
                                <th>{ "Name" }</th>
                                <th>{ "Climate Impact" }</th>
                                <th>{ "Description" }</th>
                            </tr>
                        </thead>
                        <tbody>
                            { for entries.borrow().iter().map(|entry| html! {
                                <tr class="leaderboard-item">
                                    <td class="entry-name">{ &entry.name }</td>
                                    <td class="entry-impact">{ format!("{}", entry.climate_impact) }</td>
                                    <td class="entry-description">{ &entry.description }</td>
                                </tr>
                            }) }
                        </tbody>
                    </table>
                }
            }}
        </>
    }
}

async fn handle_submit(
    new_entry: LeaderboardEntry,
    entries: UseStateHandle<Rc<RefCell<Vec<LeaderboardEntry>>>>,
    loading: UseStateHandle<bool>,
    show_form: UseStateHandle<bool>,
    error: UseStateHandle<Option<String>>,
) {
    let response = Request::post("http://127.0.0.1:8081/leaderboard")
        .header("Content-Type", "application/json")
        .json(&new_entry)
        .unwrap()
        .send()
        .await;

    match response {
        Ok(resp) if resp.status() == 201 => {
            let fetched_entries: Vec<LeaderboardEntry> = Request::get("http://127.0.0.1:8081/leaderboard")
                .send()
                .await
                .unwrap()
                .json()
                .await
                .unwrap();
            
            entries.set(Rc::new(RefCell::new(fetched_entries)));
            loading.set(false);
            show_form.set(false);
            error.set(None);
        },
        Ok(resp) => {
            error.set(Some(format!("Failed to add entry: {}", resp.status())));
        },
        Err(err) => {
            error.set(Some(format!("Network error: {}", err)));
        },
    }
}

fn main() {
    yew::Renderer::<App>::new().render();
}