
#![feature(proc_macro_hygiene, decl_macro)]
#[macro_use] extern crate rocket;

use rocket::State;
use serde::Serialize;
use std::sync::atomic::{AtomicUsize, Ordering};

#[derive(Serialize)]
struct AppData {
    count: AtomicUsize
}

#[get("/")]
fn index(app_data: State<AppData>) -> String {
    app_data.count.fetch_add(1, Ordering::Relaxed);
    serde_json::to_string_pretty(&app_data.inner()).unwrap()
}

fn main() {
    rocket::ignite()
        .manage(AppData {count: AtomicUsize::new(0)})
        .mount("/", routes![index]).launch();
}