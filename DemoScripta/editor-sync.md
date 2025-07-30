
  1. Elm side: When rendered text is selected, SendLineNumber sends line number data
  2. Elm side: The data is stored in model.editorData
  3. Elm side: The Editor module encodes this data and sets it as the editordata attribute on the custom element
  4. JS side: The custom element now observes this attribute and triggers attributeChangedCallback
  5. JS side: The callback parses the data and scrolls/highlights the corresponding lines in the editor

