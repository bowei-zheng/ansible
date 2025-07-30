# Ansible Infrastructure Management

This repository contains Ansible playbooks and configurations for managing multiple devices including:

- Personal macOS
- Work macOS  
- Windows Desktop
- Proxmox Clusters

## Structure

```
ansible/
├── darwin/                # macOS-specific configurations
│   ├── main.yml           # Main macOS playbook
│   ├── config.yml         # macOS configuration
│   ├── config.example.yml # Example configuration
│   ├── tasks/             # macOS-specific tasks
│   ├── files/             # macOS-specific files
│   └── templates/         # Jinja2 templates
├── windows/               # Windows-specific configurations (future)
├── proxmox/               # Proxmox cluster configurations (future)
├── inventory/             # Device inventory
│   └── darwin            # macOS device inventory
├── requirements.yml       # Role dependencies
├── ansible.cfg           # Ansible configuration
├── setup.sh              # Setup script
└── README.md             # Documentation
```

## Quick Start

1. Install Ansible:
   ```bash
   pip install ansible
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

3. Configure your devices in `inventory/` and customize `darwin/config.yml`

4. Run the macOS playbook:
   ```bash
   ansible-playbook -i inventory/darwin darwin/main.yml
   ```

## macOS Configuration

The macOS playbook includes:
- Homebrew package management (formula and cask)
- Dock configuration (optional)
- SSH key generation and configuration (optional)
- GitHub identity configuration (single or multi-identity)

## Contributing

This repository is completely self-contained with no external dependencies. All functionality is implemented directly in the playbook tasks, making it easy to customize and maintain. 