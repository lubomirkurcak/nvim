local M = {}

local core_dependencies = {
    {
        command = 'git',
        feature = 'plugin installation, Fugitive, and :FixLineEndingsRepo',
        advice = 'Install Git and ensure `git` is available in Neovim\'s PATH.',
    },
    {
        command = 'rg',
        feature = 'Telescope file and text search',
        advice = 'Install ripgrep: https://github.com/BurntSushi/ripgrep#installation',
    },
}

local language_dependencies = {
    {
        command = 'rust-analyzer',
        feature = 'Rust language support',
        advice = 'Install it with `rustup component add rust-analyzer`.',
    },
    {
        command = 'cargo',
        feature = 'Rust project support',
        advice = 'Install Rust through rustup: https://rustup.rs/',
    },
    {
        command = 'cargo-clippy',
        feature = 'the rust-analyzer Clippy check configured by this config',
        advice = 'Install it with `rustup component add clippy`.',
    },
    {
        command = 'ocamllsp',
        feature = 'OCaml language support',
        advice = 'Install it with `opam install ocaml-lsp-server`.',
    },
    {
        command = 'gopls',
        feature = 'Go language support',
        advice = 'Install it with `go install golang.org/x/tools/gopls@latest`.',
    },
    {
        command = 'go',
        feature = 'the Go toolchain used by gopls',
        advice = 'Install Go: https://go.dev/doc/install',
    },
    {
        command = 'deno',
        feature = 'JavaScript and TypeScript language support',
        advice = 'Install Deno: https://docs.deno.com/runtime/getting_started/installation/',
    },
    {
        command = 'vscode-html-language-server',
        feature = 'HTML language support',
        advice = 'Install it with `npm install --global vscode-langservers-extracted`.',
    },
    {
        command = 'taplo',
        feature = 'TOML language support',
        advice = 'Install it with `cargo install --features lsp --locked taplo-cli`.',
    },
    {
        command = 'lua-language-server',
        feature = 'Lua language support',
        advice = 'Install lua-language-server: https://github.com/LuaLS/lua-language-server/releases',
    },
}

local http_dependencies = {
    {
        command = 'curl',
        feature = 'sending HTTP requests with Kulala',
        advice = 'Install curl and ensure `curl` is available in Neovim\'s PATH.',
    },
    {
        command = 'tree-sitter',
        feature = 'optional Kulala parsing, highlighting, and formatting',
        advice = 'Install it with `cargo install tree-sitter-cli`.',
    },
}

local function check_dependency(dependency, severity)
    if vim.fn.executable(dependency.command) == 1 then
        local path = vim.fn.exepath(dependency.command)
        vim.health.ok(string.format('`%s` found at `%s` (%s)', dependency.command, path, dependency.feature))
        return
    end

    local message = string.format('`%s` not found (%s)', dependency.command, dependency.feature)
    vim.health[severity](message, dependency.advice)
end

local function check_group(name, dependencies, severity)
    vim.health.start(name)
    for _, dependency in ipairs(dependencies) do
        check_dependency(dependency, severity)
    end
end

function M.check()
    check_group('Core dependencies', core_dependencies, 'error')
    check_group('Language tooling', language_dependencies, 'warn')
    check_group('HTTP tooling', http_dependencies, 'warn')
end

return M
