// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use rusqlite::{params, Connection};
use serde::{Deserialize, Serialize};
use std::sync::Mutex;
use tauri::{Manager, State};
use std::fs;

#[derive(Debug, Serialize, Deserialize)]
struct Document {
    id: String,
    title: String,
    author: String,
    content: String,
    theme: String,
    #[serde(rename = "createdAt")]
    created_at: i64,
    #[serde(rename = "modifiedAt")]
    modified_at: i64,
}

#[derive(Debug, Serialize, Deserialize)]
struct CommandPayload {
    cmd: String,
    #[serde(default)]
    id: Option<String>,
    #[serde(default)]
    document: Option<Document>,
    #[serde(default)]
    name: Option<String>,
    #[serde(default)]
    file_name: Option<String>,
    #[serde(default)]
    content: Option<String>,
    #[serde(default)]
    mime_type: Option<String>,
    #[serde(default)]
    extensions: Option<Vec<String>>,
}

#[derive(Debug, Serialize)]
struct CommandResponse {
    #[serde(rename = "type")]
    response_type: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    document: Option<Document>,
    #[serde(skip_serializing_if = "Option::is_none")]
    documents: Option<Vec<Document>>,
    #[serde(skip_serializing_if = "Option::is_none")]
    id: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    #[serde(rename = "userName")]
    user_name: Option<Option<String>>,
    #[serde(skip_serializing_if = "Option::is_none")]
    name: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    #[serde(rename = "lastDocumentId")]
    last_document_id: Option<Option<String>>,
    #[serde(skip_serializing_if = "Option::is_none")]
    error: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    content: Option<String>,
}

struct AppState {
    db: Mutex<Connection>,
}

#[tauri::command]
fn handle_tauri_command(
    state: State<'_, AppState>,
    payload: CommandPayload,
) -> Result<CommandResponse, String> {
    
    let db = state.db.lock().map_err(|e| e.to_string())?;
    
    match payload.cmd.as_str() {
        "initDatabase" => init_database(&db),
        "saveDocument" => save_document(&db, payload.document),
        "loadDocument" => load_document(&db, payload.id),
        "deleteDocument" => delete_document(&db, payload.id),
        "listDocuments" => list_documents(&db),
        "saveUserName" => save_user_name(&db, payload.name),
        "loadUserName" => load_user_name(&db),
        "saveLastDocumentId" => save_last_document_id(&db, payload.id),
        "loadLastDocumentId" => load_last_document_id(&db),
        "saveFile" => save_file(payload.file_name, payload.content),
        "openFile" => open_file(payload.extensions),
        "generatePdf" => generate_pdf(payload.file_name, payload.content),
        _ => Err(format!("Unknown command: {}", payload.cmd)),
    }
}

fn init_database(conn: &Connection) -> Result<CommandResponse, String> {
    conn.execute(
        "CREATE TABLE IF NOT EXISTS documents (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            author TEXT NOT NULL,
            content TEXT NOT NULL,
            theme TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            modified_at INTEGER NOT NULL
        )",
        [],
    )
    .map_err(|e| e.to_string())?;
    
    conn.execute(
        "CREATE TABLE IF NOT EXISTS settings (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
        )",
        [],
    )
    .map_err(|e| e.to_string())?;
    
    Ok(CommandResponse {
        response_type: "databaseInitialized".to_string(),
        document: None,
        documents: None,
        id: None,
        user_name: None,
        name: None,
        last_document_id: None,
        error: None,
        content: None,
    })
}

fn save_document(conn: &Connection, document: Option<Document>) -> Result<CommandResponse, String> {
    let doc = document.ok_or("Document is required")?;
    
    conn.execute(
        "INSERT OR REPLACE INTO documents 
         (id, title, author, content, theme, created_at, modified_at) 
         VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7)",
        params![
            doc.id,
            doc.title,
            doc.author,
            doc.content,
            doc.theme,
            doc.created_at,
            doc.modified_at
        ],
    )
    .map_err(|e| e.to_string())?;
    
    Ok(CommandResponse {
        response_type: "documentSaved".to_string(),
        document: Some(doc),
        documents: None,
        id: None,
        user_name: None,
        name: None,
        last_document_id: None,
        error: None,
        content: None,
    })
}

fn load_document(conn: &Connection, id: Option<String>) -> Result<CommandResponse, String> {
    let doc_id = id.ok_or("Document ID is required")?;
    
    let doc = conn.query_row(
        "SELECT id, title, author, content, theme, created_at, modified_at 
         FROM documents WHERE id = ?1",
        params![doc_id],
        |row| {
            Ok(Document {
                id: row.get(0)?,
                title: row.get(1)?,
                author: row.get(2)?,
                content: row.get(3)?,
                theme: row.get(4)?,
                created_at: row.get(5)?,
                modified_at: row.get(6)?,
            })
        },
    )
    .map_err(|e| e.to_string())?;
    
    Ok(CommandResponse {
        response_type: "documentLoaded".to_string(),
        document: Some(doc),
        documents: None,
        id: None,
        user_name: None,
        name: None,
        last_document_id: None,
        error: None,
        content: None,
    })
}

fn delete_document(conn: &Connection, id: Option<String>) -> Result<CommandResponse, String> {
    let doc_id = id.ok_or("Document ID is required")?;
    
    conn.execute("DELETE FROM documents WHERE id = ?1", params![doc_id])
        .map_err(|e| e.to_string())?;
    
    Ok(CommandResponse {
        response_type: "documentDeleted".to_string(),
        document: None,
        documents: None,
        id: Some(doc_id),
        user_name: None,
        name: None,
        last_document_id: None,
        error: None,
        content: None,
    })
}

fn list_documents(conn: &Connection) -> Result<CommandResponse, String> {
    let mut stmt = conn
        .prepare(
            "SELECT id, title, author, content, theme, created_at, modified_at 
             FROM documents ORDER BY modified_at DESC",
        )
        .map_err(|e| e.to_string())?;
    
    let documents = stmt
        .query_map([], |row| {
            Ok(Document {
                id: row.get(0)?,
                title: row.get(1)?,
                author: row.get(2)?,
                content: row.get(3)?,
                theme: row.get(4)?,
                created_at: row.get(5)?,
                modified_at: row.get(6)?,
            })
        })
        .map_err(|e| e.to_string())?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| e.to_string())?;
    
    
    Ok(CommandResponse {
        response_type: "documentsListed".to_string(),
        document: None,
        documents: Some(documents),
        id: None,
        user_name: None,
        name: None,
        last_document_id: None,
        error: None,
        content: None,
    })
}

fn save_user_name(conn: &Connection, name: Option<String>) -> Result<CommandResponse, String> {
    let user_name = name.ok_or("User name is required")?;
    
    conn.execute(
        "INSERT OR REPLACE INTO settings (key, value) VALUES ('userName', ?1)",
        params![user_name],
    )
    .map_err(|e| e.to_string())?;
    
    Ok(CommandResponse {
        response_type: "userNameSaved".to_string(),
        document: None,
        documents: None,
        id: None,
        user_name: None,
        last_document_id: None,
        name: Some(user_name),
        error: None,
        content: None,
    })
}

fn load_user_name(conn: &Connection) -> Result<CommandResponse, String> {
    let user_name = conn
        .query_row(
            "SELECT value FROM settings WHERE key = 'userName'",
            [],
            |row| row.get::<_, String>(0),
        )
        .ok();
    
    Ok(CommandResponse {
        response_type: "userNameLoaded".to_string(),
        document: None,
        documents: None,
        id: None,
        user_name: Some(user_name),
        name: None,
        last_document_id: None,
        error: None,
        content: None,
    })
}

fn save_last_document_id(conn: &Connection, id: Option<String>) -> Result<CommandResponse, String> {
    let doc_id = id.ok_or("Document ID is required")?;
    
    conn.execute(
        "INSERT OR REPLACE INTO settings (key, value) VALUES ('lastDocumentId', ?1)",
        params![doc_id],
    )
    .map_err(|e| e.to_string())?;
    
    Ok(CommandResponse {
        response_type: "lastDocumentIdSaved".to_string(),
        document: None,
        documents: None,
        id: Some(doc_id),
        user_name: None,
        name: None,
        last_document_id: None,
        error: None,
        content: None,
    })
}

fn load_last_document_id(conn: &Connection) -> Result<CommandResponse, String> {
    let last_doc_id = conn
        .query_row(
            "SELECT value FROM settings WHERE key = 'lastDocumentId'",
            [],
            |row| row.get::<_, String>(0),
        )
        .ok();

    Ok(CommandResponse {
        response_type: "lastDocumentIdLoaded".to_string(),
        document: None,
        documents: None,
        id: None,
        user_name: None,
        name: None,
        last_document_id: Some(last_doc_id),
        error: None,
        content: None,
    })
}

fn save_file(file_name: Option<String>, content: Option<String>) -> Result<CommandResponse, String> {
    let file_name = file_name.ok_or("File name is required")?;
    let content = content.ok_or("Content is required")?;

    // Use native file dialog to let user choose save location
    let file_dialog = rfd::FileDialog::new()
        .set_file_name(&file_name);

    if let Some(path) = file_dialog.save_file() {
        fs::write(&path, content.as_bytes())
            .map_err(|e| format!("Failed to write file: {}", e))?;

        Ok(CommandResponse {
            response_type: "fileSaved".to_string(),
            document: None,
            documents: None,
            id: None,
            user_name: None,
            name: Some(path.to_string_lossy().to_string()),
            last_document_id: None,
            error: None,
            content: None,
        })
    } else {
        // Return success even when cancelled to prevent frontend freeze
        Ok(CommandResponse {
            response_type: "fileCancelled".to_string(),
            document: None,
            documents: None,
            id: None,
            user_name: None,
            name: None,
            last_document_id: None,
            error: None,
            content: None,
        })
    }
}

fn open_file(extensions: Option<Vec<String>>) -> Result<CommandResponse, String> {
    // Use native file dialog to let user choose file to open
    let mut file_dialog = rfd::FileDialog::new();

    // Add file extensions if provided
    if let Some(exts) = extensions {
        // Create a single filter for all text files
        let ext_refs: Vec<&str> = exts.iter().map(|s| s.as_str()).collect();
        file_dialog = file_dialog.add_filter("Text files", &ext_refs);
    }

    if let Some(path) = file_dialog.pick_file() {
        let content = fs::read_to_string(&path)
            .map_err(|e| format!("Failed to read file: {}", e))?;

        Ok(CommandResponse {
            response_type: "fileOpened".to_string(),
            document: None,
            documents: None,
            id: None,
            user_name: None,
            name: Some(path.to_string_lossy().to_string()),
            content: Some(content),
            last_document_id: None,
            error: None,
        })
    } else {
        // Return success even when cancelled to prevent frontend freeze
        Ok(CommandResponse {
            response_type: "fileOpenCancelled".to_string(),
            document: None,
            documents: None,
            id: None,
            user_name: None,
            name: None,
            content: None,
            last_document_id: None,
            error: None,
        })
    }
}

fn generate_pdf(file_name: Option<String>, content: Option<String>) -> Result<CommandResponse, String> {
    use std::process::Command;

    let file_name = file_name.ok_or("File name is required")?;
    let latex_content = content.ok_or("Content is required")?;

    // Create temp directory for LaTeX compilation
    let temp_dir = std::env::temp_dir().join("scripta-pdf");
    fs::create_dir_all(&temp_dir)
        .map_err(|e| format!("Failed to create temp directory: {}", e))?;

    // Write LaTeX content to temp file
    let tex_path = temp_dir.join("document.tex");
    fs::write(&tex_path, latex_content.as_bytes())
        .map_err(|e| format!("Failed to write LaTeX file: {}", e))?;

    // Check if pdflatex or xelatex is available
    let latex_cmd = if Command::new("xelatex").arg("--version").output().is_ok() {
        "xelatex"
    } else if Command::new("pdflatex").arg("--version").output().is_ok() {
        "pdflatex"
    } else {
        return Err("LaTeX is not installed. Please install TeX Live or MiKTeX to generate PDFs.".to_string());
    };

    // Run LaTeX compiler
    let output = Command::new(latex_cmd)
        .arg("-interaction=nonstopmode")
        .arg("-output-directory")
        .arg(&temp_dir)
        .arg(&tex_path)
        .output()
        .map_err(|e| format!("Failed to run LaTeX: {}", e))?;

    // Check if PDF was generated
    let pdf_path = temp_dir.join("document.pdf");
    if pdf_path.exists() {
        // Use file dialog to let user save the PDF
        let pdf_name = file_name.replace(".tex", ".pdf");
        let file_dialog = rfd::FileDialog::new()
            .set_file_name(&pdf_name)
            .add_filter("PDF files", &["pdf"]);

        if let Some(save_path) = file_dialog.save_file() {
            fs::copy(&pdf_path, &save_path)
                .map_err(|e| format!("Failed to save PDF: {}", e))?;

            Ok(CommandResponse {
                response_type: "pdfGenerated".to_string(),
                document: None,
                documents: None,
                id: None,
                user_name: None,
                name: Some(save_path.to_string_lossy().to_string()),
                last_document_id: None,
                error: None,
                content: None,
            })
        } else {
            // Return success even when cancelled to prevent frontend freeze
            Ok(CommandResponse {
                response_type: "pdfCancelled".to_string(),
                document: None,
                documents: None,
                id: None,
                user_name: None,
                name: None,
                last_document_id: None,
                error: None,
                content: None,
            })
        }
    } else {
        // LaTeX compilation failed, return error with log
        let log_path = temp_dir.join("document.log");
        let error_msg = if log_path.exists() {
            fs::read_to_string(&log_path).unwrap_or_else(|_| "Failed to read log file".to_string())
        } else {
            String::from_utf8_lossy(&output.stderr).to_string()
        };

        Err(format!("PDF generation failed: {}", error_msg))
    }
}

fn main() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .setup(|app| {
            // Get app data directory and create database path
            let app_dir = app.handle().path().app_data_dir()
                .expect("Failed to get app data directory");
            std::fs::create_dir_all(&app_dir)
                .expect("Failed to create app data directory");
            
            let db_path = app_dir.join("scripta.db");
            let conn = Connection::open(&db_path)
                .expect("Failed to open database");
            
            // Initialize database tables
            println!("About to initialize database at: {:?}", db_path);
            init_database(&conn)
                .expect("Failed to initialize database");
            println!("Database initialized successfully");
            
            // Store connection in app state
            app.manage(AppState {
                db: Mutex::new(conn),
            });
            
            println!("Looking for main window...");
            // Get the main window - handle errors gracefully
            if let Some(window) = app.get_webview_window("main") {
                println!("Found main window");
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
                println!("Window setup complete");
            } else {
                println!("WARNING: Main window not found!");
            }
            
            println!("Setup complete");
            Ok(())
        })
        .on_window_event(|window, event| {
            match event {
                tauri::WindowEvent::Resized(size) => {
                    // Ensure minimum size is respected
                    if size.width < 800 || size.height < 600 {
                        let _ = window.set_size(tauri::LogicalSize::new(
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
        .invoke_handler(tauri::generate_handler![handle_tauri_command])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}