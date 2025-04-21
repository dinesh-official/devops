You're hitting a **kernel compatibility issue with PF_RING's DKMS module**, and it's because you're using a **non-standard kernel version (`6.0.0`)**, which PF_RING doesn't officially support.

---

### 🧨 Problem Summary:
```
ERROR (dkms apport): kernel package linux-headers-6.0.0-060000-generic is not supported
Error! Bad return status for module build on kernel: 6.0.0
```

PF_RING's `pfring-dkms` needs to compile against your current kernel headers — but this kernel is too new or custom and not supported.

---

### ✅ Fix Options:

#### 🥇 **Option 1: Downgrade to a Supported Kernel (Recommended)**
Use Ubuntu's official, stable kernel (`5.15` for Ubuntu 22.04):

```bash
sudo apt install linux-image-5.15.0-91-generic linux-headers-5.15.0-91-generic
```

After install:

```bash
sudo update-grub
sudo reboot
```

On reboot, verify:

```bash
uname -r  # Should show: 5.15.x
```

Then re-run:
```bash
sudo apt install pfring-dkms
```

---

Here’s how to switch to the `5.15.0-91-generic` kernel **from the terminal**, without needing GRUB UI (especially useful for headless/cloud servers):

---

### ✅ Step-by-Step to Boot into `5.15.0-91-generic`

#### 🔍 1. **Check if kernel is installed**
Run:
```bash
ls /boot/vmlinuz-*
```

You should see:
```
/boot/vmlinuz-5.15.0-91-generic
/boot/vmlinuz-6.0.0-060000-generic
```

---

#### ✏️ 2. **Update GRUB to boot into 5.15 by default**

Edit GRUB config:
```bash
sudo nano /etc/default/grub
```

Find the line:
```bash
GRUB_DEFAULT=0
```

Change it to:
```bash
GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 5.15.0-91-generic"
```

> Make sure the exact name matches the GRUB menu entry — you can list them with the command below if needed.

---

#### 📋 (Optional) To see GRUB entries:

```bash
grep menuentry /boot/grub/grub.cfg
```

Look for the exact entry line like:
```
menuentry 'Ubuntu, with Linux 5.15.0-91-generic' --class ubuntu ...
```

---

#### 💾 3. **Save and update GRUB**
```bash
sudo update-grub
```

---

#### 🔁 4. **Reboot**
```bash
sudo reboot
```

---

#### ✅ 5. **After reboot, verify**
```bash
uname -r
```

It should return:
```
5.15.0-91-generic
```

---
