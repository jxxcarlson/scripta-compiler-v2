// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use tauri::Manager;

fn main() {
    tauri::Builder::default()
        .setup(|app| {
            // Get the main window - handle errors gracefully
            if let Some(window) = app.get_window("main") {
                // Set minimum size
                let _ = window.set_min_size(Some(tauri::LogicalSize::new(800.0, 600.0)));
                
                // Optional: Set window size
                let _ = window.set_size(tauri::LogicalSize::new(1400.0, 900.0));
                
                // Center the window
                let _ = window.center();
                
                // Make sure window is visible
                let _ = window.show();
                
                // Set focus
                let _ = window.set_focus();
            }
            
            Ok(())
        })
        .on_window_event(|event| {
            match event.event() {
                tauri::WindowEvent::Resized(size) => {
                    // Ensure minimum size is respected
                    if size.width < 800 || size.height < 600 {
                        let _ = event.window().set_size(tauri::LogicalSize::new(
                            (size.width as f64).max(800.0),
                            (size.height as f64).max(600.0)
                        ));
                    }
                }
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