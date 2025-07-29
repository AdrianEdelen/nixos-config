# NixOS Deployment Workflow

A guide for installing and managing NixOS systems with `nixos-anywhere`, `sops`, `disko`, and `facter`.

---

## 1. Prerequisites

### Add Your SSH Public Key

A system running nix, flakes, and ssh. NOTE: this can be a live iso, but you must have or generate ssh keys.

To gain SSH access to newly deployed machines, add your public SSH key (e.g., `your-name.pub`) to the `ssh/public-keys/` directory and commit the file. The configuration will automatically include all keys from this directory. this is required for nixos-anywhere.

Alternatively, if forking, or you do not want the existing keys to have access, you can modify or replace the existing keyfiles with your own key/s. 

---

## 2. Managing Secrets (sops)

All secrets management should be done from within the Nix development shell to ensure the correct tools are available.

1.  **Enter the shell:**
    ```bash
    nix develop
    ```
2.  **Edit secrets:**
    ```bash
    sops <path/to/secrets.yaml>
    ```

---

## 3. End-to-End Installation Guide

This outlines the process for installing a new machine from scratch.
1.  **enter the nix shell** `nix develop`
2.  **Add your public SSH key** to the `ssh/public-keys/` directory.
3.  **Commit the new key file** to the repository.
4.  **Build the custom NixOS live ISO.** The resulting ISO will be in a `./result` symlink.
    ```bash
    nix build .#live
    ```
5.  Boot the target machine using the newly built ISO.
6.  From your local workstation, prepare the `age` private key for `sops-nix` by creating the required directory structure for `--extra-files`.
    ```bash
    # Example:
    mkdir -p ./tmp/var/lib/sops/age
    cp /path/to/your/key.txt ./tmp/var/lib/sops/age/keys.txt
    ```
7.  Run the `nixos-anywhere` command to provision the new system.
    ```bash
    nix run github:nix-community/nixos-anywhere -- \
      --extra-files ./tmp \
      --generate-hardware-config nixos-facter ./facter.json \
      -f .#<target-flake> \
      --target-host root@<target-ip>
    ```

---

## 4. Core Concepts

### Provisioning Files with --extra-files

The `--extra-files <path>` option copies the entire directory structure from `<path>` into the target system's root (`/`).

To use this, you must recreate the desired final path on your local machine first. For example, to place a key at `/var/lib/sops/age/keys.txt` on the target, you would create a local directory `./tmp`, and inside it, create the path `var/lib/sops/age/keys.txt`. Then you would pass `./tmp` to the command.

This allows files to be placed directly without needing additional configuration like `environment.etc`.

### `facter.json` Handling

`facter.json` is used to create a hardware configuration on the fly for `nixos-anywhere`.

The file is committed to source control as an **empty file**. This ensures it is tracked by Git and available to the Nix build process.

To prevent local changes from showing up in `git status`, we tell Git to ignore changes to this specific file:
```bash
git update-index --assume-unchanged ./facter.json