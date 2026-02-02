.. _`lsp_attach`:

*********
LspAttach
*********

``LspAttach`` ``event``
=======================

When we create an ``autocommand`` for ``LspAttach``

.. code-block::

   vim.api.nvim_create_autocmd("LspAttach", {
     group = vim.api.nvim_create_augroup("vvnraman.lsp.config", { clear = true }),
     callback = function(event)
        -- some code
     end
   })

This is the event which comes in

.. code-block::

   [INFO  Tue Nov 18 07:06:50 2025] /home/vvnraman/.config/nvim/lua/plugins/lsp/lsp.lua:43: {
     buf = 1,
     data = {
       client_id = 1
     },
     event = "LspAttach",
     file = "/home/vvnraman/my/code/cppcon-2022-cpp-neovim-toy-calc/src/app/app_main.cpp",
     group = 32,
     id = 63,
     match = "/home/vvnraman/my/code/cppcon-2022-cpp-neovim-toy-calc/src/app/app_main.cpp"
   }


``vim.lsp.get_client_by_id(event.data.client_id)``
==================================================

.. code-block::

   [INFO  Tue Nov 18 07:06:50 2025] /home/vvnraman/.config/nvim/lua/plugins/lsp/lsp.lua:46: {
     _is_stopping = false,
     _log_prefix = "LSP[clangd]",
     _on_attach_cbs = { <function 1> },
     _on_exit_cbs = { <function 2> },
     _on_init_cbs = { <function 3> },
     _trace = "off",
     attached_buffers = { true },
     cancel_request = <function 4>,
     capabilities = {
       general = {
         positionEncodings = { "utf-8", "utf-16", "utf-32" }
       },
       offsetEncoding = <1>{ "utf-8", "utf-16" },
       textDocument = {
         callHierarchy = {
           dynamicRegistration = false
         },
         codeAction = {
           codeActionLiteralSupport = {
             codeActionKind = {
               valueSet = { "", "quickfix", "refactor", "refactor.extract", "refactor.inline", "refactor.rewrite", "source", "source.organizeImports" }
             }
           },
           dataSupport = true,
           dynamicRegistration = true,
           isPreferredSupport = true,
           resolveSupport = {
             properties = { "edit", "command" }
           }
         },
         codeLens = {
           dynamicRegistration = false,
           resolveSupport = {
             properties = { "command" }
           }
         },
         completion = {
           completionItem = {
             commitCharactersSupport = true,
             deprecatedSupport = true,
             documentationFormat = { "markdown", "plaintext" },
             insertReplaceSupport = true,
             insertTextModeSupport = <2>{
               valueSet = { 1, 2 }
             },
             labelDetailsSupport = true,
             preselectSupport = true,
             resolveSupport = {
               properties = <3>{ "documentation", "additionalTextEdits", "insertTextFormat", "insertTextMode", "command" }
             },
             snippetSupport = true,
             tagSupport = {
               valueSet = <4>{ 1 }
             }
           },
           completionItemKind = {
             valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
           },
           completionList = {
             itemDefaults = <5>{ "commitCharacters", "editRange", "insertTextFormat", "insertTextMode", "data" }
           },
           contextSupport = true,
           dynamicRegistration = false,
           editsNearCursor = true,
           insertTextMode = 1
         },
         declaration = {
           linkSupport = true
         },
         definition = {
           dynamicRegistration = true,
           linkSupport = true
         },
         diagnostic = {
           dynamicRegistration = false,
           tagSupport = {
             valueSet = { 1, 2 }
           }
         },
         documentHighlight = {
           dynamicRegistration = false
         },
         documentSymbol = {
           dynamicRegistration = false,
           hierarchicalDocumentSymbolSupport = true,
           symbolKind = {
             valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }
           }
         },
         foldingRange = {
           dynamicRegistration = false,
           foldingRange = {
             collapsedText = true
           },
           foldingRangeKind = {
             valueSet = { "comment", "imports", "region" }
           },
           lineFoldingOnly = true
         },
         formatting = {
           dynamicRegistration = true
         },
         hover = {
           contentFormat = { "markdown", "plaintext" },
           dynamicRegistration = true
         },
         implementation = {
           linkSupport = true
         },
         inlayHint = {
           dynamicRegistration = true,
           resolveSupport = {
             properties = { "textEdits", "tooltip", "location", "command" }
           }
         },
         publishDiagnostics = {
           dataSupport = true,
           relatedInformation = true,
           tagSupport = {
             valueSet = { 1, 2 }
           }
         },
         rangeFormatting = {
           dynamicRegistration = true,
           rangesSupport = true
         },
         references = {
           dynamicRegistration = false
         },
         rename = {
           dynamicRegistration = true,
           prepareSupport = true
         },
         semanticTokens = {
           augmentsSyntaxTokens = true,
           dynamicRegistration = false,
           formats = { "relative" },
           multilineTokenSupport = false,
           overlappingTokenSupport = true,
           requests = {
             full = {
               delta = true
             },
             range = false
           },
           serverCancelSupport = false,
           tokenModifiers = { "declaration", "definition", "readonly", "static", "deprecated", "abstract", "async", "modification", "documentation", "defaultLibrary" },
           tokenTypes = { "namespace", "type", "class", "enum", "interface", "struct", "typeParameter", "parameter", "variable", "property", "enumMember", "event", "function", "method", "macro", "keyword", "modifier", "comment", "string", "number", "regexp", "operator", "decorator" }
         },
         signatureHelp = {
           dynamicRegistration = false,
           signatureInformation = {
             activeParameterSupport = true,
             documentationFormat = { "markdown", "plaintext" },
             parameterInformation = {
               labelOffsetSupport = true
             }
           }
         },
         synchronization = {
           didSave = true,
           dynamicRegistration = false,
           willSave = true,
           willSaveWaitUntil = true
         },
         typeDefinition = {
           linkSupport = true
         }
       },
       window = {
         showDocument = {
           support = true
         },
         showMessage = {
           messageActionItem = {
             additionalPropertiesSupport = true
           }
         },
         workDoneProgress = true
       },
       workspace = {
         applyEdit = true,
         configuration = true,
         didChangeConfiguration = {
           dynamicRegistration = false
         },
         didChangeWatchedFiles = {
           dynamicRegistration = false,
           relativePatternSupport = true
         },
         inlayHint = {
           refreshSupport = true
         },
         semanticTokens = {
           refreshSupport = true
         },
         symbol = {
           dynamicRegistration = false,
           symbolKind = {
             valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }
           }
         },
         workspaceEdit = {
           resourceOperations = { "rename", "create", "delete" }
         },
         workspaceFolders = true
       }
     },
     commands = {},
     config = {
       capabilities = {
         offsetEncoding = <table 1>,
         textDocument = {
           completion = {
             completionItem = {
               commitCharactersSupport = true,
               deprecatedSupport = true,
               insertReplaceSupport = true,
               insertTextModeSupport = <table 2>,
               labelDetailsSupport = true,
               preselectSupport = true,
               resolveSupport = {
                 properties = <table 3>
               },
               snippetSupport = true,
               tagSupport = {
                 valueSet = <table 4>
               }
             },
             completionList = {
               itemDefaults = <table 5>
             },
             contextSupport = true,
             dynamicRegistration = false,
             editsNearCursor = true,
             insertTextMode = 1
           }
         }
       },
       cmd = { "clangd" },
       filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
       name = "clangd",
       on_attach = <function 1>,
       on_init = <function 3>,
       root_dir = "/home/vvnraman/my/code/cppcon-2022-cpp-neovim-toy-calc",
       root_markers = { "compile_commands.json" },
       single_file_support = false
     },
     dynamic_capabilities = {
       capabilities = <6>{},
       client_id = 1,
       get = <function 5>,
       register = <function 6>,
       supports = <function 7>,
       supports_registration = <function 8>,
       unregister = <function 9>
     },
     flags = {},
     get_language_id = <function 10>,
     handlers = {},
     id = 1,
     initialized = true,
     is_stopped = <function 11>,
     messages = {
       messages = {},
       name = "clangd",
       progress = {},
       status = {}
     },
     name = "clangd",
     notify = <function 12>,
     offset_encoding = "utf-8",
     on_attach = <function 13>,
     progress = {
       _idx_read = 0,
       _idx_write = 0,
       _items = {},
       _size = 51,
       pending = {},
       <metatable> = {
         __call = <function 14>,
         __index = {
           clear = <function 15>,
           peek = <function 16>,
           pop = <function 17>,
           push = <function 18>
         }
       }
     },
     registrations = <table 6>,
     request = <function 19>,
     request_sync = <function 20>,
     requests = {},
     root_dir = "/home/vvnraman/my/code/cppcon-2022-cpp-neovim-toy-calc",
     rpc = {
       is_closing = <function 21>,
       notify = <function 22>,
       request = <function 23>,
       terminate = <function 24>
     },
     server_capabilities = {
       astProvider = true,
       callHierarchyProvider = true,
       clangdInlayHintsProvider = true,
       codeActionProvider = {
         codeActionKinds = { "quickfix", "refactor", "info" }
       },
       compilationDatabase = {
         automaticReload = true
       },
       completionProvider = {
         resolveProvider = false,
         triggerCharacters = { ".", "<", ">", ":", '"', "/", "*" }
       },
       declarationProvider = true,
       definitionProvider = true,
       documentFormattingProvider = true,
       documentHighlightProvider = true,
       documentLinkProvider = {
         resolveProvider = false
       },
       documentOnTypeFormattingProvider = {
         firstTriggerCharacter = "\n",
         moreTriggerCharacter = {}
       },
       documentRangeFormattingProvider = true,
       documentSymbolProvider = true,
       executeCommandProvider = {
         commands = { "clangd.applyFix", "clangd.applyRename", "clangd.applyTweak" }
       },
       foldingRangeProvider = true,
       hoverProvider = true,
       implementationProvider = true,
       inactiveRegionsProvider = true,
       inlayHintProvider = true,
       memoryUsageProvider = true,
       referencesProvider = true,
       renameProvider = {
         prepareProvider = true
       },
       selectionRangeProvider = true,
       semanticTokensProvider = {
         full = {
           delta = true
         },
         legend = {
           tokenModifiers = { "declaration", "definition", "deprecated", "deduced", "readonly", "static", "abstract", "virtual", "dependentName", "defaultLibrary", "usedAsMutableReference", "usedAsMutablePointer", "constructorOrDestructor", "userDefined", "functionScope", "classScope", "fileScope", "globalScope" },
           tokenTypes = { "variable", "variable", "parameter", "function", "method", "function", "property", "variable", "class", "interface", "enum", "enumMember", "type", "type", "unknown", "namespace", "typeParameter", "concept", "type", "macro", "modifier", "operator", "bracket", "label", "comment" }
         },
         range = false
       },
       signatureHelpProvider = {
         triggerCharacters = { "(", ")", "{", "}", "<", ">", "," }
       },
       standardTypeHierarchyProvider = true,
       textDocumentSync = {
         change = 2,
         openClose = true,
         save = true
       },
       typeDefinitionProvider = true,
       typeHierarchyProvider = true,
       workspaceSymbolProvider = true
     },
     server_info = {
       name = "clangd",
       version = "clangd version 20.1.0 (https://github.com/llvm/llvm-project 24a30daaa559829ad079f2ff7f73eb4e18095f88) linux+grpc x86_64-unknown-linux-gnu"
     },
     settings = {},
     stop = <function 25>,
     supports_method = <function 26>,
     workspace_folders = { {
         name = "/home/vvnraman/my/code/cppcon-2022-cpp-neovim-toy-calc",
         uri = "file:///home/vvnraman/my/code/cppcon-2022-cpp-neovim-toy-calc"
       } },
     <metatable> = <7>{
       __index = <table 7>,
       _add_workspace_folder = <function 27>,
       _get_language_id = <function 28>,
       _get_registration = <function 29>,
       _get_registration_options = <function 30>,
       _notification = <function 31>,
       _on_error = <function 32>,
       _on_exit = <function 33>,
       _process_request = <function 34>,
       _register = <function 35>,
       _register_dynamic = <function 36>,
       _remove_workspace_folder = <function 37>,
       _resolve_handler = <function 38>,
       _run_callbacks = <function 39>,
       _server_request = <function 40>,
       _supports_registration = <function 41>,
       _text_document_did_open_handler = <function 42>,
       _unregister = <function 43>,
       _unregister_dynamic = <function 44>,
       cancel_request = <function 45>,
       create = <function 46>,
       exec_cmd = <function 47>,
       initialize = <function 48>,
       is_stopped = <function 49>,
       notify = <function 50>,
       on_attach = <function 51>,
       request = <function 52>,
       request_sync = <function 53>,
       stop = <function 54>,
       supports_method = <function 55>,
       write_error = <function 56>
     }
   }

