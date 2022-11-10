echo "Step 1. Checking update"
sudo apt-get update
sudo apt --fix-missing update
echo "Step 2. Installing Ansible"
sudo apt install ansible -y
echo "Step 3. Checking ansible version"
ansible --version
echo "Step 4. Change ownership"
chown adminuser:adminuser /home/adminuser/.ssh
echo "Step 5. Change permission"
chmod 700 /home/adminuser/.ssh
echo "Step 6. Copy public key"
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwqIWycEqpYplsVYWXcgJxwJh/OHd/mWoR49CLUBeD4jb/JpKDCh0J6dEwO4jQCchUFI3DzefysfaKSYU5ACr4PSE5ULogzdcez8vfxprpnaCrzqYZ3HJX6SnHD2TbgmY8pv5W4v0MD0O3n3QyNs0oOWKqQoD/ACjaN8V/hmgM5ak+Cc9+KdGg57y2ph3UHzYDjNezw1Kl36ve+6x7uXjBw/+Yfn079CMAnLszhnzcz1nUP+lySgHPKTRauN6ZkOh0SDkYJcjvu5vi/ci5RmW+QoKxTMtVgxKGU5rKIj1e4yel/yv6vyS5JS4DhRWoS1Puu0d86hKjd1YFxAiop8D9E/qe6buE8yqiIU6uHSLZMaFutpAsQIJgatzq3m4uxBEBGVZCaEISoQuGQjlrzFjQr9ixRAlojZv9elZYCBjeLsn+1AjCQ6oi6B5244TiqlqjaQvMh+n0lr0Nk1yHsK4GON/EDWGM+HRQp4+AJ4iBV6HlmBWg4tBdy4uUAbKX8PM= einfochips@AHMLPT3475" > /home/adminuser/.ssh/authorized_keys
echo "Step 7. Change permission of authorized key"
chmod 600 /home/adminuser/.ssh/authorized_keys
echo "Step 8. Change ownership of authorized key"
chown adminuser:adminuser /home/adminuser/.ssh/authorized_keys







