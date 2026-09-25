Hermit OS - TCP server
======================

1. Install Rust Std Hermit. The hermit enabled only for specific Rust versions. 1.94.0 as of Sep 25, 2026.
```shell
rustup target add x86_64-unknown-hermit
```
or manually on Windows
```
curl -L https://github.com/hermit-os/rust-std-hermit/releases/download/1.94.0/rust-std-1.94.0-x86_64-unknown-hermit.tar.gz -o rust-std-1.94.0-x86_64-unknown-hermit.tar.gz
./install.ps1 -RustVersion 1.94.0 -HermitStdlib rust-std-1.94.0-x86_64-unknown-hermit.tar.gz
```
2. Build the project
```shell
cargo build --target x86_64-unknown-hermit
```
3. Download multiboot loaded loader
```powershell
curl -L https://github.com/hermit-os/loader/releases/download/v0.5.7/hermit-loader-x86_64-multiboot -o hermit-loader-x86_64-multiboot
```
4. Run QEMU
```powershell
qemu-system-x86_64.exe `
     -cpu qemu64,apic,fsgsbase,fxsr,rdrand,rdtscp,xsave,xsaveopt `
     -smp 1 -m 128M `
     -device isa-debug-exit,iobase=0xf4,iosize=0x04 `
     -display none -serial stdio `
     -kernel hermit-loader-x86_64-multiboot `
     -initrd target/x86_64-unknown-hermit/debug/hermit `
     -netdev user,id=u1,hostfwd=tcp::9975-:9975,hostfwd=udp::9975-:9975,net=192.168.76.0/24,dhcpstart=192.168.76.9 `
     -device virtio-net-pci,netdev=u1,disable-legacy=on,packed=on,mq=on
```

It is important to add network device with port forwarding to expose the TCP server to the host.

Now you can connect to the TCP server from the host using `telnet` or any other TCP client. For example:
```shell
telnet localhost 9975
```

Just type something, and see that it's displayed in the QEMU console.

## Notes

1. The sample use main branch of the kernel, because fix for the memory mapping happens after 0.13.2 was released. If you reading this, you may want to use released version from latest tag.
2. Use 1.94.0 stable release or latest tag to avoid issues with memory mapping.
