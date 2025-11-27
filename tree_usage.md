Verification confirmed: The codebase overwhelmingly uses the maca/elm-rose-tree package (RoseTree.Tree):

  - 22 files use RoseTree.Tree (maca package)
  - Only 4 files use Tree (zwilias package):
    - MiniLaTeX/Util.elm - has utility functions depth and size
    - MiniLaTeX/Pretty.elm
    - MicroScheme/Environment.elm
    - Render/Pretty.elm (the file we're working on)

  Key finding: ScriptaV2.Compiler.parseScripta returns List (RoseTree.Tree.Tree ExpressionBlock) - it uses the maca package, not zwilias.

  Conclusion: It appears that at some point the codebase was migrated from zwilias to maca, but a few files were left using the old zwilias package for
  specific utility functions. The core compiler infrastructure (all parsing, forests, compilation) uses maca's RoseTree.Tree.
