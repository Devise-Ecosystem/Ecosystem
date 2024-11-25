# Ecosystem

## Overview

This document outlines our plan to host an ecosystem of open-source applications on a VPS machine. Our aim is to create a cohesive and flexible environment that enables team collaboration, project management, and productivity using a range of open-source software.
A complete solution for self-hosting various open-source applications with minimal setup time. Deploy your own suite of productivity tools with just a few commands.

## 🚀 Quick Start

```bash
git clone https://github.com/alexanderritik/Ecosystem.git
cd Ecosystem
./setup.sh
```

This ecosystem will provide an integrated workspace with everything from messaging to project management, secure document storage, and scheduling, enabling our team to work seamlessly and productively.


## 🛠 Available Services
- **Nextcloud**: File Storage
- **Keycloak**: Authentication
- ... more to be added

## 📋 Requirements

- Docker & Docker Compose
- Domain name with DNS access
- VPS with minimum specifications:
  - 4GB RAM
  - 2 CPU cores
  - 50GB storage

## 🔧 Installation

1. Clone the repository
2. Copy `.env.example` to `.env`
3. Run `./setup.sh`
4. Follow the interactive prompts

## 📚 Documentation

Detailed documentation is available in the [docs](./docs) directory:
- [Installation Guide](./docs/installation.md)
- [Configuration Guide](./docs/configuration.md)
- [Backup & Restore](./docs/backup-restore.md)
- [Updating Services](./docs/updating.md)
- [Troubleshooting](./docs/troubleshooting.md)

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
