# Cursor Plugin Management (Self-contained)

This playbook includes support for automatically installing Cursor plugins/extensions using only built-in Ansible modules and shell commands. No external dependencies required!

## Prerequisites

- Cursor must be installed (it's already included in the `homebrew_cask_apps` list)
- No additional Ansible collections or external dependencies needed

## Configuration

### Enable Cursor Plugin Management

In `darwin/config.yml`, set:
```yaml
configure_cursor_plugins: true
```

### Add Plugins/Extensions

Add your desired plugins to the `cursor_plugins` list in `darwin/config.yml`:

```yaml
cursor_plugins:
  - "ms-python.python"
  - "eamodio.gitlens"
```

## Running the Playbook

### Run Only Cursor Plugin Tasks
```bash
ansible-playbook darwin/main.yml --tags cursor
```

### Run All Tasks Including Cursor Plugins
```bash
ansible-playbook darwin/main.yml
```

## How It Works

The implementation uses Ansible modules and Cursor's built-in CLI interface:
- **Idempotent**: Only installs extensions that aren't already installed
- **Ansible modules**: Uses `stat`, `file`, and `set_fact` for better control
- **Minimal shell commands**: Only uses shell for extension listing and installation
- **Self-contained**: No external Ansible collections required

## Popular Plugin Recommendations

Here are some popular plugins you might want to add (all verified to work):

### Language Support
- `ms-python.python` - Python support
- `ms-vscode.vscode-typescript-next` - TypeScript support
- `golang.go` - Go support
- `rust-lang.rust-analyzer` - Rust support

### Web Development
- `bradlc.vscode-tailwindcss` - Tailwind CSS IntelliSense
- `esbenp.prettier-vscode` - Code formatter

### Git & Productivity
- `eamodio.gitlens` - Git supercharged
- `ms-azuretools.vscode-docker` - Docker support
- `anysphere.remote-containers` - Remote containers

### Data & File Types
- `redhat.vscode-yaml` - YAML support
- `janisdd.vscode-edit-csv` - CSV editor

### Themes & Icons
- `pkief.material-icon-theme` - Material Icon Theme
- `zhuangtongfa.material-theme` - Material Theme
- `dracula-theme.theme-dracula` - Dracula Theme

## Troubleshooting

### Plugin Installation Issues
If plugins fail to install, ensure:
1. Cursor is properly installed in `/Applications/Cursor.app`
2. The plugin names are correct (check the VS Code marketplace)
3. You have internet connectivity to download extensions



### Manual Plugin Installation
You can also install plugins manually using Cursor's command palette:
1. Open Cursor
2. Press `Cmd+Shift+P`
3. Type "Extensions: Install Extensions"
4. Search for and install your desired plugins

## Self-Contained Benefits

- **No external dependencies**: Uses only built-in Ansible modules
- **No ansible-galaxy required**: Everything works out of the box
- **Consistent with existing playbook**: Follows the same patterns as other tasks
- **Reliable**: Uses Cursor's official CLI interface
- **Focused**: Only handles plugin installation, keeping it simple and maintainable 