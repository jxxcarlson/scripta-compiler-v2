# Directions for Updating Announcement

## Overview

The Announcement document is created from `src/AppData.elm` when the app first starts or when no existing Announcement document is found in localStorage. If you want to update the Announcement content, you need to update the source file and then clear the old version from localStorage.

## Steps to Update Announcement

1. **Edit the source file**
   - Open `src/AppData.elm`
   - Modify the `defaultDocumentText` string with your new content
   - Save the file

2. **Rebuild the application**
   ```bash
   sh make.sh
   ```

3. **Clear the old Announcement from browser storage**
   - Open the app in your browser
   - Open the browser console (F12 or right-click → Inspect → Console)
   - Run these commands:
   
   ```javascript
   // First, check what content is currently stored
   window.debugScripta.showAnnouncementContent()
   
   // Remove the old Announcement document
   window.debugScripta.forceUpdateAnnouncement()
   ```

4. **Reload the page**
   - Do a hard reload: Cmd+Shift+R (Mac) or Ctrl+Shift+F5 (Windows)
   - The app will create a new Announcement document with your updated content

## Why This Process is Necessary

The app stores documents in the browser's localStorage. When you update `AppData.elm`, you're only changing the default content that gets used when creating a NEW document. Any existing Announcement document in localStorage will continue to be loaded until you explicitly remove it.

## Troubleshooting

If you still see the old content after following these steps:

1. Check that your build succeeded without errors
2. Verify the browser is loading the new JavaScript file (check the timestamp in the Network tab)
3. Try clearing all browser cache and localStorage for the site
4. Make sure you're looking at the correct URL/port

## Alternative: Clear All Data

If you're having persistent issues, you can clear all Scripta data and start fresh:

```javascript
window.debugScripta.clearAllScriptaData()
```

**Warning**: This will delete ALL your documents, not just the Announcement.