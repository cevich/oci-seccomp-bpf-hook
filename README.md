[![Build Status](https://travis-ci.org/containers/oci-seccomp-bpf-hook.svg?branch=master)](https://travis-ci.org/containers/oci-seccomp-bpf-hook)

# oci-seccomp-bpf-hook

OCI hooks to generate seccomp profiles by tracing the syscalls made by the container. The generated profile would whitelist all the syscalls made and blacklist every other syscall.

The syscalls are traced by launching a binary by using the prestart OCI hook. The binary started spawns a child process which attaches function `enter_trace` to the `raw_syscalls:sys_ente`r tracepoint using eBPF. The function looks at all the syscalls made on the system and writes the syscalls which have the same PID namespace as the container to the perf buffer. The perf buffer is read by the process in the userspace and generates a seccomp profile when the container exits.

There are a few limitations to this approach:

* Needs CAP_SYS_ADMIN to run
* Compiles C code on the fly
* Cannot use podman run --rm along with this ability

To build it, we need extra dependencies namely bcc-devel and kernel-headers for Fedora and bcc-tools and linux-headers-[..] for Ubuntu.

Interface:

```
sudo podman run --annotation io.containers.trace-syscall=[absolute path to the json file] IMAGE COMMAND
```

The profile will be created at the path provided to the annotation.
