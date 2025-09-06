# Server-Status

## Overview

A lightweight, real-time system monitoring tool built entirely in Bash, designed for UNIX-like environments. It provides a comprehensive, at-a-glance summary of critical system metrics in a terminal-based dashboard with ANSI-colored visual elements for improved readability.

## ⚡ Features

- Real-time system monitoring in the terminal
- Clean, color-coded interface using ANSI and tput
- Uptime, load averages, memory, CPU, and storage usage
- Top 5 active processes by CPU and memory
- Dynamic usage bars for quick visual insights
- Graceful exit with terminal state restoration
- No external dependencies — pure Bash + standard Linux tools

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/edimurg/Server-Status.git
```
Allow permissions:

```bash
chmod +x server_stats.sh
```
## 📝 Usage

Run the tool:
```bash
./server_stats.sh 
```

