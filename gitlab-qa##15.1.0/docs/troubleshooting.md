# Troubleshooting

## Mac OS with ARM processors & Docker Desktop

You might encounter the following errors when running tests locally, using Gitlab QA, on Mac OS with `ARM` processors.  These errors usually stem from using Docker images that are based on Linux/AMD64 platforms.

- `MADV_DONTNEED` does not work (memset will be used instead)

    ```shell
    <jemalloc>: MADV_DONTNEED does not work (memset will be used instead)
    <jemalloc>: (This is the expected behaviour if you are running under QEMU)
    bundler: failed to load command: bin/qa (bin/qa)
    #0 0x004000724133 <unknown>: unknown error: Chrome failed to start: crashed. (Selenium::WebDriver::Error::UnknownError)
        (unknown error: DevToolsActivePort file doesn't exist)
        (The process started from chrome location /usr/bin/google-chrome is no longer running,
        so ChromeDriver is assuming that Chrome has crashed.)
    ```

- `QA::Support::Repeater::WaitExceededError`

    ```shell
    QA::Support::Repeater::WaitExceededError:
        Page did not fully load. This could be due to an unending async request or loading icon.
    ```

- `Selenium::WebDriver::Error::UnknownError`

    ```shell
    Selenium::WebDriver::Error::UnknownError:
        unknown error: session deleted because of page crash
        from tab crashed
        (Session info: headless chrome=113.0.5672.126)
    ```

To resolve these issues:

1. Do not use `/dev/shm` shared memory. Set `CHROME_DISABLE_DEV_SHM` environment variable to `true`.

    ```shell
    $ export CHROME_DISABLE_DEV_SHM=true
    # Disable Chrome shared memory
    ```

2. Enable **Rosetta for x86/amd64 emulation on Apple Silicon**
    1. Using Docker (Based on Docker Desktop ~v4.22.1):
        1. Open **Settings** in Docker Desktop
        1. Go to **Features in development**
        1. Enable **Use Rosetta for x86/amd64 emulation on Apple Silicon** setting
        1. Select **Apply & restart**
    1. Using Rancher Desktop
        1. Open **Preferences > Virtual Machine > Emulation**
        1. Enable **VZ**
        1. Enable **Enable Rosetta support** 
    1. Using Colima
        1. Start with `colima start --arch aarch64 --vm-type=vz --vz-rosetta`
        1. If this fails remove current configuration with `colima delete default` and retry
