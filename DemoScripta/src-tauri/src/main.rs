// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use tauri::Manager;

fn main() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .setup(|app| {
            // Get the main window - handle errors gracefully
            if let Some(window) = app.get_webview_window("main") {
                // Set window title
                let _ = window.set_title("Scripta Live");
                
                // Optional: Set window size
                let _ = window.set_size(tauri::Size::Physical(tauri::PhysicalSize {
                    width: 1400,
                    height: 900,
                }));
                
                // Center the window
                let _ = window.center();
                
                // Make sure window is visible
                let _ = window.show();
                
                // Set focus
                let _ = window.set_focus();
            }
            
            Ok(())
        })
        .on_window_event(|_window, event| {
            match event {
                tauri::WindowEvent::CloseRequested { .. } => {
                    println!("Window close requested");
                }
                tauri::WindowEvent::Destroyed => {
                    println!("Window destroyed");
                }
                _ => {}
            }
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}