
// https://blog.datacamp.engineering/codemirror-6-getting-started-7fd08f467ed2
// BRACKETS: https://stackoverflow.com/questions/70758962/how-to-configure-custom-brackets-for-markdown-for-codemirror-closebrackets
// BRACKETS: https://bl.ocks.org/curran/d8de41605fa68b627defa9906183b92f

import { basicSetup } from "codemirror";
import { EditorState, EditorSelection, StateEffect } from "@codemirror/state";
import { EditorView, keymap, ViewPlugin, Decoration } from "@codemirror/view";
import { closeBrackets } from "@codemirror/autocomplete";
import { indentWithTab } from "@codemirror/commands";

const chalky = "#e5c07b",
    coral = "#e06c75",
    cyan = "#56b6c2",
    invalid = "#ffffff",
    ivory = "#dee4ef", // CHANGED (brightened) // "#abb2bf",
    stone = "#7d8799", // Brightened compared to original to increase contrast
    malibu = "#61afef",
    sage = "#98c379",
    whiskey = "#d19a66",
    violet = "#c678dd",
    darkBackground = "#21252b",
    highlightBackground = "#2c313a", // "#6c313a"
    background = "#282c34",
    tooltipBackground = "#353a42",
    selection = "#9E4451", // "#3E4451",
    cursor = "#528bff"

let myTheme = EditorView.theme({


    "&": {
        color: ivory,
        backgroundColor: background
    },

    ".cm-content": {
        caretColor: cursor
    },

    ".cm-cursor, .cm-dropCursor": {borderLeftColor: "rgba(255, 80, 0, 0.5 )", borderLeftWidth: "8px"},

    // affects refined selection (RL) and also plain RL selection
    "&.cm-focused > .cm-scroller > .cm-selectionLayer .cm-selectionBackground, .cm-selectionBackground, .cm-content ::selection":
           {backgroundColor: "rgba(255, 0, 0, 0.8 )"},

    ".cm-panels": {backgroundColor: darkBackground, color: ivory},
    ".cm-panels.cm-panels-top": {borderBottom: "2px solid black"},
    ".cm-panels.cm-panels-bottom": {borderTop: "2px solid black"},

    ".cm-searchMatch": {
        backgroundColor:  "#00a1ff59",
        outline: "1px solid #457dff"
    },
    ".cm-searchMatch.cm-searchMatch-selected": {
        backgroundColor: "#aa222259",

    },

    // ACTIVE LINE
    ".cm-activeLine": {backgroundColor: "#000ff44"},

    ".cm-selectionMatch": {backgroundColor: "rgba( 0, 120, 120,  0.5 )" },

    // "&.cm-focused > .cm-scroller > .cm-selectionLayer .cm-selectionBackground" : {
    //     backgroundColor: "#5555ff",
    //     color: "#fff"
    // },

    "&.cm-focused .cm-matchingBracket, &.cm-focused .cm-nonmatchingBracket": {
        backgroundColor: "#aa0047"
    },

    ".cm-gutters": {
        backgroundColor: background,
        color: stone,
        border: "none"
    },

    ".cm-activeLineGutter": {
        backgroundColor: highlightBackground
    },

    ".cm-foldPlaceholder": {
        backgroundColor: "transparent",
        border: "none",
        color: "#ddd"
    },

    ".cm-tooltip": {
        border: "none",
        backgroundColor: tooltipBackground
    },
    ".cm-tooltip .cm-tooltip-arrow:before": {
        borderTopColor: "transparent",
        borderBottomColor: "transparent"
    },
    ".cm-tooltip .cm-tooltip-arrow:after": {
        borderTopColor: tooltipBackground,
        borderBottomColor: tooltipBackground
    },
    ".cm-tooltip-autocomplete": {
        "& > ul > li[aria-selected]": {
            backgroundColor: highlightBackground,
            color: ivory
        },


    },

    // Style for leading spaces with dots
    ".cm-leading-space": {
        backgroundImage: `url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='16'%3E%3Ccircle cx='2' cy='10' r='1' fill='rgba(255,255,255,0.5)'/%3E%3C/svg%3E")`,
        backgroundRepeat: "repeat-x",
        backgroundPosition: "-2px center"
    },

    // Custom search panel - CSS Grid layout
    ".cm-panel.cm-search": {
        padding: "8px 12px 10px",
        fontSize: "16px",
        position: "relative",
        display: "grid",
        gridTemplateColumns: "auto auto auto auto 1fr",
        gridTemplateRows: "auto auto auto",
        gap: "4px",
        width: "100%",
        maxWidth: "100%",
        overflow: "hidden",
        alignItems: "center"
    },
    
    // Base styles
    ".cm-panel.cm-search input": {
        fontSize: "16px",
        padding: "4px 8px",
        height: "32px",
        margin: "2px 0"
    },
    ".cm-panel.cm-search button": {
        fontSize: "14px",
        padding: "4px 12px",
        height: "32px",
        margin: "2px 0"
    },
   
    
    // Row 1: Search input and buttons
    ".cm-panel.cm-search input[type='search']": {
        width: "200px",
        gridRow: "1",
        gridColumn: "1"
    },
    ".cm-panel.cm-search button[name='next']": {
        gridRow: "1",
        gridColumn: "2"
    },
    ".cm-panel.cm-search button[name='prev']": {
        gridRow: "1",
        gridColumn: "3"
    }, 
    ".cm-panel.cm-search button[name='select']": {
        gridRow: "1",
        gridColumn: "4"
    },
    
    // Row 2: Replace input and buttons
    ".cm-panel.cm-search input[name='Replace']": {
        width: "200px",
        gridRow: "2",
        gridColumn: "1"
    },
    // Use sibling selector for Replace input
    ".cm-panel.cm-search input:not([type='checkbox']) ~ input:not([type='checkbox'])": {
        width: "200px",
        gridRow: "2",
        gridColumn: "1"
    },
    ".cm-panel.cm-search button[name='replace']": {
        gridRow: "2",
        gridColumn: "2"
    },
    ".cm-panel.cm-search button[name='replaceAll']": {
        gridRow: "2",
        gridColumn: "3"
    },
    
    // Row 3: All checkboxes in a single grid cell
    ".cm-panel.cm-search label": {
        gridRow: "3",
        gridColumn: "1 / -1",  // Span all columns to avoid grid gaps
        position: "relative",
        display: "inline-flex",  // Use flex for better alignment
        alignItems: "center",  // Vertically center checkbox and label
        marginRight: "20px",
        whiteSpace: "nowrap"
    },
    
    // Use absolute positioning to reorder
    ".cm-panel.cm-search label:nth-of-type(1)": {
        position: "relative",
        left: "0"
    },
    ".cm-panel.cm-search label:nth-of-type(3)": {
        position: "absolute",
        left: "120px",  // Position after match case
        top: "-1px",  // Raise slightly to align
        display: "inline-flex",
        alignItems: "center"
    },
    ".cm-panel.cm-search label:nth-of-type(2)": {
        position: "absolute", 
        left: "220px",  // Position after by word
        top: "-1px",  // Raise slightly to align
        display: "inline-flex",
        alignItems: "center",
        marginRight: "0"
    },
    
    // Make checkboxes more visible
    ".cm-panel.cm-search label input[type='checkbox']": {
        marginRight: "4px"
    },
    
    // Hide any br elements that might interfere with grid layout
    ".cm-panel.cm-search br": {
        display: "none"
    },
    
    // Close button positioning
    ".cm-panel.cm-search button[name='close']": {
        position: "absolute",
        top: "8px",
        right: "32px",
        gridRow: "1",
        gridColumn: "5",
        color: "white"
    }



}, {dark: true})

// Plugin to mark leading spaces (doesn't replace them, just marks them)
const leadingSpaceHighlighter = ViewPlugin.fromClass(class {
    constructor(view) {
        this.decorations = this.markLeadingSpaces(view)
    }
    
    update(update) {
        if (update.docChanged || update.viewportChanged) {
            this.decorations = this.markLeadingSpaces(update.view)
        }
    }
    
    markLeadingSpaces(view) {
        const marks = []
        
        for (const {from, to} of view.visibleRanges) {
            const text = view.state.sliceDoc(from, to)
            let pos = from
            
            for (const line of text.split('\n')) {
                let spaces = 0
                while (spaces < line.length && line[spaces] === ' ') {
                    spaces++
                }
                
                if (spaces > 0) {
                    marks.push(
                        Decoration.mark({
                            class: "cm-leading-space"
                        }).range(pos, pos + spaces)
                    )
                }
                
                pos += line.length + 1 // +1 for newline
            }
        }
        
        return Decoration.set(marks.sort((a, b) => a.from - b.from))
    }
}, {
    decorations: v => v.decorations
})

function sendText(editor) {
    const event = new CustomEvent('text-change',
        { 'detail': {position: editor.state.selection.main.head, source: editor.state.doc.toString()}
            , 'bubbles':true, 'composed': true});
    editor.dom.dispatchEvent(event);
}

function sendCursor(editor, position) {
    const event = new CustomEvent('cursor-change',
        { 'detail': {position: position, source:  editor.state.doc.toString()}
            , 'bubbles':true, 'composed': true});
    editor.dom.dispatchEvent(event);
}

function sendSelectedText(editor, str) {
    // console.log("@@JS sendSelectedText (dispatch)", str)
    const event = new CustomEvent('selected-text', { 'detail': str , 'bubbles':true, 'composed': true});
    editor.dom.dispatchEvent(event);
}

function resetEditor(editor, str) {

        // console.log("@@JS_resetEditor, str.length ", str.length, " resetting ...")

        let panelTheme = EditorView.theme({
            '&': { maxHeight: '100%' },
            '.cm-gutter,.cm-content': { minHeight: '100px' },
            '.cm-scroller': { overflow: 'auto' },
        })

        EditorView.setState(editor, EditorState.create({
            extensions: [
                basicSetup,
                myTheme,
                panelTheme,
                EditorView.lineWrapping,
                keymap.of([indentWithTab]),
                closeBrackets(),
                leadingSpaceHighlighter,
                EditorView.updateListener.of((v)=> {
                    if(v.docChanged) {
                        sendText(editor)
                    }
                })
            ]
            , doc: str // Initialize with content directly
        }))

    resetEditorText(editor, str)
}
function setEditorText(editor, str) {
    if (str == "") {
        // console.log("@@JS setEditorText (empty string), doing nothing")
    } else {

        const currentValue = editor.state.doc.toString();
        const endPosition = currentValue.length;
        // console.log("@@(CM) function setEditorText (1), str.length ", str.length, str.slice(0,20))


        editor.dispatch({
            changes: {
                from: 0,
                to: endPosition,
                insert: str
            }
        })
    }
}

function resetEditorText(editor, str) {
    if (typeof str != 'string') {
        console.log("@@JS_resetEditorText, Error: str is not a string")
    }
    else {
        console.log("@@JS_resetEditorText, replacing", editor.state.doc.length, "chars with", str.length, "chars:", str.slice(0, 50))

        editor.dispatch({
            changes: {
                from: 0,
                to: editor.state.doc.length,
                insert: str
            }
        })
    }
}

class CodemirrorEditor extends HTMLElement {

    static get observedAttributes() { return ['selection', 'load', 'refineselection', 'editordata', 'text']; }
    // static get observedAttributes() { return ['selection', 'load', 'editordata', 'text']; }

    constructor(self) {

        self = super(self)
        console.log("@@JS CM EDITOR: In constructor")
        
        // Initialize properties for managing refinement timing
        self.pendingRefinement = null;
        self.paragraphSelectionTime = 0;
        self.lastRefinementText = null;
        
        // Initialize sync state
        self.cmdKeyPressed = false;

        return self
    }


    connectedCallback() {

        console.log("@@JS CM EDITOR: In connectedCallback")
        console.log("@@JS CM EDITOR: Setting up cmd key tracking...")

        let editorNode = document.querySelector('#editor-here');


        let panelTheme = EditorView.theme({
            '&': { maxHeight: '100%' },
            '.cm-gutter,.cm-content': { minHeight: '100px' },
            '.cm-scroller': { overflow: 'auto' },
          })

           // Set up editor
            const options = {}
            let editor = new EditorView({
                       state: EditorState.create({
                         extensions: [basicSetup
                           , myTheme
                           , panelTheme
                           , EditorView.lineWrapping
                           , keymap.of([indentWithTab])
                           , closeBrackets()
                           , leadingSpaceHighlighter
                           // Below: send updated text from CM to Elm
                           , EditorView.updateListener.of((v)=> {
                               if(v.docChanged) {
                                   sendText(editor)
                               }
                             })
                           ]
                       , doc: ""
                       }),
                       parent: document.getElementById("editor-here")

                     })

            editorNode.onclick = (event) =>
                 {  sendCursor(editor, (editor.posAtCoords({x: event.clientX, y: event.clientY}))) };

            this.dispatchEvent(new CustomEvent("editor-ready", { bubbles: true, composed: true, detail: editor }))
            this.editor = editor
            this.editor.lastLineNumberFromClick = 0;
            this.editor.requestMeasure()
            
            // Track cmd/meta key state
            const instance = this;
            console.log("@@JS CM EDITOR: Adding keydown listener");
            document.addEventListener('keydown', (e) => {
                if (e.metaKey || e.ctrlKey) {  // metaKey for Mac Cmd, ctrlKey as fallback
                    instance.cmdKeyPressed = true;
                    console.log("@@cmd key pressed");
                }
            });
            
            document.addEventListener('keyup', (e) => {
                if (e.key === 'Meta' || e.key === 'Control') {
                    // Send selection when cmd key is released
                    const selection = editor.state.selection.main;
                    const selectedText = editor.state.sliceDoc(selection.from, selection.to);
                    if (selectedText.trim() !== '') {
                        console.log("@@cmd key released - sending selection:", selectedText);
                        sendSelectedText(editor, selectedText);
                    } else {
                        console.log("@@cmd key released - no selection");
                    }
                    instance.cmdKeyPressed = false;
                }
            });
            
            // No longer need selection change listener - we'll send on cmd key release
            console.log("@@JS CM EDITOR: Selection will be sent on cmd key release");

    } // end connectedCallback


    // Yes, you can set attributes directly on the element using the setAttribute method or
    // by accessing the attribute as a property of the element. Here are two examples:
    // Using setAttribute method:
    //    const editorElement = document.querySelector('codemirror-editor');
    //    editorElement.setAttribute('text', 'New text content');
    // Using property access:
    //    const editorElement = document.querySelector('codemirror-editor');
    //    editorElement.text = 'New text content';

    // Handle communication with Elm
    attributeChangedCallback(attr, oldVal, newVal) {
            function attributeChangedCallback_(editor, attr, oldVal, newVal, instance) {
               switch (attr) {

                   case "load": // load the editor with the given text
                      // if (typeof newVal == 'string') {resetEditor(editor, newVal)}
                       console.log("@@JS LOAD attribute changed:", newVal ? newVal.substring(0, 50) + "..." : "null");
                       if (typeof newVal == 'string') {resetEditorText(editor, newVal)}
                       break

                   case "editordata":
                       // receive info from Elm (see Main.editor_)
                       // Clicks on rendered text cause the editor to
                       // scroll to the corresponding lines of the source text
                       // and highlight those lines
                       console.log("@@JS EDITORDATA attribute changed:", newVal);
                       
                       // Clear any pending refinements since we're doing a new paragraph selection
                       if (self.pendingRefinement) {
                           clearTimeout(self.pendingRefinement);
                           self.pendingRefinement = null;
                           console.log("@#@ Cleared pending refinement due to new paragraph selection");
                       }
                       
                       let data = JSON.parse(newVal)
                       
                       // Mark that we're doing a paragraph selection
                       self.paragraphSelectionTime = Date.now();
                       // Store the paragraph bounds for comparison
                       self.lastParagraphSelection = { begin: data.begin, end: data.end };
                       
                       // Debug: Log current selection state before update
                       console.log("@#@ BEFORE editordata - current selection:", {
                           from: editor.state.selection.main.from,
                           to: editor.state.selection.main.to,
                           ranges: editor.state.selection.ranges.length
                       });
                       
                       // Force a fresh calculation of line positions by getting the current document
                       let currentDoc = editor.state.doc;
                       let totalLines = currentDoc.lines;
                       console.log("@#@ Document has", totalLines, "total lines");
                       
                       // Validate line numbers
                       if (data.begin < 1 || data.begin > totalLines || data.end < 1 || data.end > totalLines) {
                           console.error("@#@ ERROR: Invalid line numbers - begin:", data.begin, "end:", data.end, "totalLines:", totalLines);
                           break;
                       }
                       
                       let loc =  currentDoc.line(data.begin);
                       let loc2 = currentDoc.line(data.end);
                       
                       // Debug: Show what text we're selecting
                       let selectedText = currentDoc.sliceString(loc.from, loc2.to);
                       console.log("@#@ dispatch (1) selecting lines", data.begin, "to", data.end)
                       console.log("@#@ line locations: from", loc.from, "to", loc2.to)
                       console.log("@#@ selected text preview:", selectedText.substring(0, 50) + "...")
                       
                       // Calculate midpoint of selection for better centering
                       let selectionMidpoint = Math.floor((loc.from + loc2.to) / 2);
                       
                       // Clear any existing selection first
                       editor.dispatch({
                           selection: EditorSelection.create([EditorSelection.range(loc.from, loc2.to)]),
                           effects: EditorView.scrollIntoView(selectionMidpoint, {y: "center"})
                       });
                       
                       // Force the view to update by requesting a measure
                       editor.requestMeasure();
                       
                       // Debug: Log selection state after update
                       console.log("@#@ AFTER editordata - new selection:", {
                           from: editor.state.selection.main.from,
                           to: editor.state.selection.main.to
                       });
                       
                       // Additional debug: Check if view matches state after a small delay
                       setTimeout(() => {
                           let viewSelection = editor.state.selection.main;
                           let visibleRanges = editor.visibleRanges;
                           console.log("@#@ POST-UPDATE CHECK - selection:", {
                               from: viewSelection.from,
                               to: viewSelection.to,
                               visibleRanges: visibleRanges.map(r => ({from: r.from, to: r.to}))
                           });
                       }, 100);
                       break;

                   case "refineselection":
                       // Clear any existing pending refinement
                       if (self.pendingRefinement) {
                           clearTimeout(self.pendingRefinement);
                           self.pendingRefinement = null;
                       }

                       let refined_selection_data = JSON.parse(newVal);
                       console.log("@#@ refineselection - scheduling refinement", refined_selection_data)

                       // Delay the refinement slightly
                       self.pendingRefinement = setTimeout(() => {
                           // Check if this is stale refinement data (same text but different paragraph)
                           if (self.lastRefinementText === refined_selection_data.text && 
                               self.lastParagraphSelection &&
                               (refined_selection_data.begin !== self.lastParagraphSelection.begin ||
                                refined_selection_data.end !== self.lastParagraphSelection.end)) {
                               console.log("@#@ refineselection - WARNING: reused text data for different paragraph - skipping", {
                                   text: refined_selection_data.text.substring(0, 30) + "...",
                                   oldLines: self.lastParagraphSelection ? 
                                       `${self.lastParagraphSelection.begin}-${self.lastParagraphSelection.end}` : 'none',
                                   newLines: `${refined_selection_data.begin}-${refined_selection_data.end}`
                               });
                               self.pendingRefinement = null;
                               return;
                           }
                           
                           // Store this refinement text
                           self.lastRefinementText = refined_selection_data.text;
                           
                           console.log("@#@ refineselection - executing", refined_selection_data)

                           // Get the enclosing text of the selection
                           let first_line_index = refined_selection_data.begin
                           let last_line_index = refined_selection_data.end
                           console.log("@@first, last line offsets", first_line_index, last_line_index)
                           let first_line_location = editor.state.doc.line(first_line_index);
                           let last_line_location = editor.state.doc.line(last_line_index);
                           let enclosing_text = editor.state.sliceDoc(first_line_location.from, last_line_location.to);


                           console.log("@@first, last line offsets", first_line_location, last_line_location)
                           console.log ("@@enclosing_text", enclosing_text)


                           // Get the offsets for the selected rendered text
                           let headOffset, anchorOffset

                           // Put the offsets in the right order
                           if (refined_selection_data.focusOffset < refined_selection_data.anchorOffset) {
                               headOffset = refined_selection_data.focusOffset
                               anchorOffset = refined_selection_data.anchorOffset
                           } else {
                               anchorOffset = refined_selection_data.focusOffset
                               headOffset = refined_selection_data.anchorOffset
                           }

                           // Get the "target_text" corresponding to the selection in the rendered text
                           let target_text = refined_selection_data.text.slice(headOffset, anchorOffset)

                           // Create a selection object based on the parsed data
                           let starting_index_of_refined_selection = enclosing_text.indexOf(target_text);
                           let starting_position_of_refined_selection = first_line_location.from + starting_index_of_refined_selection;

                           // Set the refined selection
                           var a = starting_position_of_refined_selection
                           var b = starting_position_of_refined_selection + target_text.length
                           console.log("@@(start, finish)", a,b)
                           let refined_sel = {anchor : starting_position_of_refined_selection, head : starting_position_of_refined_selection + target_text.length }
                           console.log("@@dispatching selection (2)")
                           // Calculate midpoint of selection for better centering
                           let refinedSelMidpoint = Math.floor((a + b) / 2);
                           editor.dispatch({
                               selection: refined_sel,
                               effects: EditorView.scrollIntoView(refinedSelMidpoint, {y: "center"})
                           });
                           
                           // Clear the pending refinement reference
                           self.pendingRefinement = null;
                       }, 50); // 50ms delay to allow paragraph selection to complete

                       break;



                  case "text":
                        setEditorText(editor, newVal);
                        break

                  case "selection":
                       // This attribute is no longer used for toggle mode
                       // Sync now happens automatically with shift+selection
                       break
             }
           } // end attributeChangedCallback_

         if (this.editor) { attributeChangedCallback_(this.editor, attr, oldVal, newVal, this)  }
         else { console.log("attr text", "this.editor not defined")}

         } // end attributeChangedCallback

  }

customElements.define("codemirror-editor", CodemirrorEditor); // (2)


