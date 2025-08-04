#!/bin/bash

# Ansible Infrastructure Management Setup Script

set -e

echo "🚀 Setting up Ansible Infrastructure Management..."

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "❌ Ansible is not installed. Please install Ansible first:"
    echo "See https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html for more information."
    exit 1
fi

echo "✅ Ansible is installed"

echo "✅ No external dependencies required - this is a self-contained playbook"

# Create config file if it doesn't exist
if [ ! -f "darwin/config.yml" ]; then
    echo "📝 Creating macOS configuration file..."
    cp darwin/config.example.yml darwin/config.yml
    echo "✅ Created darwin/config.yml - please customize it for your devices"
else
    echo "✅ macOS configuration file already exists"
fi

# Create inventory if it doesn't exist
if [ ! -f "inventory/darwin" ]; then
    echo "📝 Creating macOS inventory file..."
    echo "[darwin_devices]" > inventory/darwin
    echo "# Local macOS device" >> inventory/darwin
    echo "localhost ansible_host=127.0.0.1 ansible_connection=local" >> inventory/darwin
    echo "" >> inventory/darwin
    echo "# Remote macOS devices (uncomment and customize as needed)" >> inventory/darwin
    echo "# personal ansible_host=<your_personal_macOS_ip> ansible_user=your_username" >> inventory/darwin
    echo "# work ansible_host=<your_work_macOS_ip> ansible_user=your_username" >> inventory/darwin
    echo "" >> inventory/darwin
    echo "[darwin_devices:vars]" >> inventory/darwin
    echo "# Default settings for remote SSH connections" >> inventory/darwin
    echo "ansible_connection=ssh" >> inventory/darwin
    echo "ansible_python_interpreter=/usr/bin/python3" >> inventory/darwin
    echo "# Uncomment and set if you use SSH keys" >> inventory/darwin
    echo "# ansible_ssh_private_key_file=~/.ssh/id_ed25519" >> inventory/darwin
    echo "✅ Created inventory/darwin - please add your macOS devices"
else
    echo "✅ macOS inventory file already exists"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit darwin/config.yml to customize your configuration"
echo "2. Edit inventory/darwin to add your macOS devices"
echo "3. Run the macOS playbook:"
echo "   ansible-playbook -i inventory/darwin darwin/main.yml"
echo ""
echo "For more information, see README.md" 