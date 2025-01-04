![Webnestify Logo](https://webnestify.cloud/wp-content/uploads/2023/11/webnestify-logo-dark-300x109.png)

# SSH Config Change Monitor

A Bash script to monitor changes in your SSH configuration file (`~/.ssh/config`) and send notifications for **added** or **removed** hosts via webhooks.

## Features

- **Monitor SSH Config File**: Watches the `~/.ssh/config` file for changes.
- **Detect Changes**: Identifies added and removed `Host` and `HostName` entries.
- **Webhook Integration**:
  - Sends notifications for added hosts to a designated webhook.
  - Sends notifications for removed hosts to a separate webhook.
- **State Management**: Maintains the last known state of the SSH config for accurate change detection.

---

## How It Works

1. The script parses the `~/.ssh/config` file and extracts `Host` and `HostName` pairs.
2. It compares the current state of the SSH config with the last known state stored in a temporary file.
3. Sends:
   - **Added Hosts**: To the webhook specified in the `WEBHOOK_ADDED` variable.
   - **Removed Hosts**: To the webhook specified in the `WEBHOOK_REMOVED` variable.
4. Updates the state file for future comparisons.

---

## Requirements

- **Bash**: Ensure Bash is installed on your system.
- **curl**: Required for sending webhook requests.

---

## Windows Compatibility

On Windows machines, you can use **Git Bash** to execute this script. Git Bash provides a Unix-like environment on Windows and supports tools like `bash`, `curl`, and `cron`.

### Steps:

1. **Install Git Bash**:
   - Download and install Git for Windows from [git-scm.com](https://git-scm.com).
   - Open Git Bash from the Start Menu after installation.

2. **Run the Script**:
   - Navigate to the directory containing the script in Git Bash.
   - Execute the script using:
     ```bash
     ./update.sh
     ```

3. **Automate Execution**:
   - Use a cron-like scheduling tool in Git Bash to run the script periodically if needed:
     ```bash
     crontab -e
     ```
   - Add an entry to execute the script at your desired interval:
     ```bash
     */5 * * * * /path/to/update.sh
     ```

---

## Customization

- **Change State File Location**:
  Modify the `TEMP_STATE` variable to specify a different path for the state file.
  
- **Customize Webhook Payloads**:
  Adjust the `PAYLOAD` construction to include additional fields or modify the structure.

---

## License

This project is licensed under the [MIT License](LICENSE).

## About Webnestify

Hi! I’m Simon, the founder of **Webnestify**. At Webnestify, we are passionate about empowering businesses and developers by providing cutting-edge tools, tutorials, and resources for managing web infrastructure. Our mission is to make complex web hosting and management tasks accessible, cost-effective, and **open-source friendly**.

We specialize in:
- **Managed Services**: Including broadcast email servers, Cloudflare configuration, and infrastructure optimization, dedicated hosting and much more.
- **Educational Content**: Tutorials, livestreams, and courses for platforms like Docker, WordPress, Cloudflare, and more.
- **Open-Source Advocacy**: We support open-source projects by creating tailored solutions that give you full control over your data.

### Why Webnestify?
We believe in enabling users to:
- **Save Money** by reducing reliance on costly SaaS tools.
- **Own Their Data** with privacy-focused, self-hosted solutions.
- **Simplify Management** with intuitive tools and educational resources.

Visit our website to learn more: [Webnestify.cloud](https://webnestify.cloud) 