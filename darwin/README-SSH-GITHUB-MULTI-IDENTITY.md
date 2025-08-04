# SSH and GitHub Multi-Identity Setup

This Ansible playbook configures your macOS system to use multiple SSH identities and GitHub accounts (personal and work) with automatic directory-based switching.

## Overview

The setup allows you to:
- Use different GitHub accounts for different projects
- Automatically switch Git user/email based on directory location
- Use separate SSH keys for each account
- Clone repositories using standard `git@github.com` URLs
- Choose which account is your default (primary) account

## How It Works

### File Structure
The setup creates the following configuration files:

```
~/.gitconfig              # Main Git config with conditional includes
~/.gitconfig_work         # Work-specific user settings (when personal is default)
~/.gitconfig_personal     # Personal-specific user settings (when work is default)
~/.ssh/config             # SSH configuration with host aliases
~/.ssh/id_ed25519        # Default SSH key (based on github_default_ssh_account)
~/.ssh/id_ed25519_{{ github_work_ssh_host }}    # Work SSH key (when personal is default)
~/.ssh/id_ed25519_{{ github_personal_ssh_host }} # Personal SSH key (when work is default)
```

### Git Configuration
- **Main config**: `~/.gitconfig` contains default account settings and conditional includes
- **Work config**: `~/.gitconfig_work` contains work-specific user settings (when personal is default)
- **Personal config**: `~/.gitconfig_personal` contains personal-specific user settings (when work is default)
- **Directory-based switching**: Git automatically detects the directory and applies the appropriate configuration

### SSH Configuration
- **Global defaults**: `Host *` section with `IdentitiesOnly yes` for security
- **Default account**: Uses the standard SSH key (`~/.ssh/id_ed25519`) with `Host github.com`
- **Secondary account**: Uses a specific SSH key (`~/.ssh/id_ed25519_{{ github_work_ssh_host | default('work') }}` or `~/.ssh/id_ed25519_{{ github_personal_ssh_host | default('personal') }}`) with custom hostname
- **Host aliases**: Secondary account uses a custom hostname (e.g., `git@{{ github_work_ssh_host | default('work') }}:org/repo.git`)

## Configuration

### Configuration Validation

The playbook includes comprehensive validation to prevent invalid configurations:

- **Mutual exclusivity**: Only one SSH configuration and one GitHub configuration can be enabled
- **Dependency checking**: GitHub multi-identity requires SSH multi-identity
- **Required variables**: Validates that all required variables are set
- **SSH key compatibility**: Checks existing SSH keys and warns about potential mismatches
- **Clear error messages**: Provides specific guidance on how to fix configuration issues

### Basic Setup

1. Copy `config.example.yml` to `config.yml`:
   ```bash
   cp config.example.yml config.yml
   ```

2. Enable multi-identity configurations:
   ```yaml
   configure_github_multi_identity: true
   configure_ssh_multi_identity: true
   ```

3. Configure your accounts:

   **Personal Account:**
   ```yaml
   github_personal_email: "your-personal-email@example.com"
   git_personal_name: "Your Personal Name"
   github_personal_ssh_host: "personal"
   github_personal_directory: "~/repositories/personal/"
   ```

   **Work Account:**
   ```yaml
   github_work_email: "your-work-email@company.com"
   git_work_name: "Your Work Name"
   github_work_directory: "~/repositories/work/"
   github_work_ssh_host: "work"
   ```

4. Choose your default account:
   ```yaml
   # Set to 'personal' or 'work'
   github_default_ssh_account: "personal"
   ```

### Configuration Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `configure_ssh_single_identity` | Enable single SSH identity setup | `false` |
| `configure_ssh_multi_identity` | Enable multi-identity SSH setup | `false` |
| `configure_github_single_identity` | Enable single GitHub identity setup | `false` |
| `configure_github_multi_identity` | Enable multi-identity GitHub setup | `false` |
| `github_personal_email` | Personal GitHub email | Required |
| `git_personal_name` | Personal Git username | Required |
| `github_personal_ssh_host` | SSH hostname for personal account | `"personal"` |
| `github_personal_directory` | Directory for personal repos | `"~/repositories/personal/"` |
| `github_work_email` | Work GitHub email | Required |
| `git_work_name` | Work Git username | Required |
| `github_work_directory` | Directory for work repos | `"~/repositories/work/"` |
| `github_work_ssh_host` | SSH hostname for work account | `"work"` |
| `github_default_ssh_account` | Default account (`personal` or `work`) | `"personal"` |



## Usage Examples

### When Personal is Default (`github_default_ssh_account: "personal"`)

**Git Configuration:**
- All repositories use personal name/email by default
- Only repos in `~/repositories/work/` use work name/email

**SSH Keys:**
- Personal: `~/.ssh/id_ed25519` (default)
- Work: `~/.ssh/id_ed25519_{{ github_work_ssh_host | default('work') }}`

**Cloning Repositories:**
```bash
# Personal repositories (anywhere)
git clone git@github.com:username/personal-repo.git

# Work repositories (anywhere)
git clone git@work:organization/work-repo.git

# Work repositories (in work directory - will use work email automatically)
cd ~/repositories/work/
git clone git@work:organization/work-repo.git
```

### When Work is Default (`github_default_ssh_account: "work"`)

**Git Configuration:**
- All repositories use work name/email by default
- Only repos in `~/repositories/personal/` use personal name/email

**SSH Keys:**
- Work: `~/.ssh/id_ed25519` (default)
- Personal: `~/.ssh/id_ed25519_{{ github_personal_ssh_host | default('personal') }}`

**Cloning Repositories:**
```bash
# Work repositories (anywhere)
git clone git@github.com:organization/work-repo.git

# Personal repositories (anywhere)
git clone git@personal:username/personal-repo.git

# Personal repositories (in personal directory - will use personal email automatically)
cd ~/repositories/personal/
git clone git@personal:username/personal-repo.git
```

## Setup Instructions

1. **Run the Ansible playbook:**
   ```bash
   ansible-playbook main.yml
   ```

2. **SSH keys and configuration must be explicitly enabled:**
   - Set `configure_ssh_single_identity: true` for single SSH identity
   - Set `configure_ssh_multi_identity: true` for multi-identity SSH setup
   - SSH keys are generated and added to the SSH agent
   - SSH configuration is created with proper host aliases
   - SSH configurations are handled separately from GitHub configurations

3. **GitHub-specific instructions are provided:**
   - Detailed instructions for adding SSH keys to GitHub accounts
   - Connection testing commands
   - Repository cloning examples

4. **Add SSH keys to GitHub:**
   - Follow the instructions displayed by the playbook
   - Add both SSH keys (personal and work) with descriptive titles

3. **Test your connections:**
   ```bash
   # Test personal account
   ssh -T git@github.com  # (if personal is default)
   ssh -T git@personal    # (if work is default)

   # Test work account
   ssh -T git@work        # (if personal is default)
   ssh -T git@github.com  # (if work is default)
   ```

4. **Create your directory structure:**
   ```bash
   # If personal is default
   mkdir -p ~/repositories/work/

   # If work is default
   mkdir -p ~/repositories/personal/
   ```

## Directory Structure

The setup creates the following files:

```
~/.gitconfig                    # Git configuration with conditional includes
~/.ssh/config                   # SSH configuration with host aliases
~/.ssh/id_ed25519              # Default SSH key (based on github_default_ssh_account)
~/.ssh/id_ed25519_{{ github_work_ssh_host | default('work') }}    # Work SSH key (when personal is default)
~/.ssh/id_ed25519_{{ github_personal_ssh_host | default('personal') }} # Personal SSH key (when work is default)
```

## Playbook Structure

The configuration is now modular with consistent naming:

### SSH Configuration
- **`tasks/ssh-single-identity.yml`**: Handles single SSH identity setup
- **`tasks/ssh-multi-identity.yml`**: Handles multi-identity SSH setup
- **`templates/ssh-config-single.j2`**: Template for single SSH configuration
- **`templates/ssh-config-multi.j2`**: Template for multi-identity SSH configuration

### GitHub Configuration
- **`tasks/github-single-identity.yml`**: Handles single GitHub identity setup
- **`tasks/github-multi-identity.yml`**: Handles multi-identity GitHub setup

## Troubleshooting

### SSH Key Issues
- Ensure SSH keys are added to the SSH agent: `ssh-add ~/.ssh/id_ed25519*`
- Check SSH key permissions: `chmod 600 ~/.ssh/id_ed25519*`
- Verify SSH config permissions: `chmod 600 ~/.ssh/config`

### SSH Config Conflicts
- The setup automatically backs up your existing SSH config before making changes
- A fresh SSH config is generated each time to avoid conflicts and duplicates
- Your original config is preserved as `~/.ssh/config.backup.{timestamp}`
- If you need to restore your original config, copy it back from the backup

### SSH Key Mismatches
- **GitHub multi-identity without SSH multi-identity**: The playbook will **fail** to prevent a broken state
  - This covers: no SSH keys, single SSH key, or multiple SSH keys with different names
  - You must enable SSH multi-identity: `configure_ssh_multi_identity: true`
  - Or use GitHub single identity: `configure_github_single_identity: true`
  - For existing keys with different names, consider renaming them or enabling SSH multi-identity
- **GitHub multi-identity with no SSH configuration**: The playbook will **fail** to prevent a broken state
  - When both `configure_ssh_single_identity: false` and `configure_ssh_multi_identity: false`
  - GitHub multi-identity requires SSH configuration to work properly
  - Enable SSH multi-identity or use GitHub single identity instead
- **Multiple SSH keys + GitHub single identity**: The playbook will warn about unused keys
  - Consider using GitHub multi-identity to utilize all your SSH keys
  - Or remove unused SSH keys if they're not needed
- **No SSH keys + SSH single identity**: The playbook will generate appropriate keys based on your configuration
- **No SSH keys + no SSH configuration**: The playbook will skip SSH configuration entirely
  - This is valid when you don't need SSH keys or will configure them manually
- **GitHub single identity + no SSH configuration**: The playbook will warn but continue
  - You'll need to manually configure SSH keys for GitHub authentication
  - Consider enabling SSH single identity for automatic SSH key generation

### Git Configuration Issues
- Check current Git configuration: `git config --list`
- Verify directory-based switching: `git config --show-origin user.email`

### Connection Issues
- Test SSH connections individually
- Check GitHub SSH key settings
- Verify hostname aliases in `~/.ssh/config`

## Advanced Configuration

### Custom Directory Paths
You can customize the directory paths for automatic switching:

```yaml
github_personal_directory: "~/projects/personal/"
github_work_directory: "~/company/projects/"
```

### Custom SSH Hostnames
You can use custom SSH hostnames for better organization:

```yaml
github_personal_ssh_host: "github-personal"
github_work_ssh_host: "github-work"
```

### Multiple Work Accounts
For multiple work accounts, you can extend this setup by:
1. Adding additional conditional includes in the Git config
2. Creating additional SSH host aliases
3. Generating additional SSH keys

## Notes

- The setup preserves existing SSH configuration by appending new entries
- SSH keys are automatically added to the SSH agent
- Directory paths support tilde expansion (`~` for home directory)
- The configuration is fully parameterized for easy sharing across team members 