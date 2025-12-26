# Run QA tests against a remote Selenium grid

The QA tests have the ability to be run against a local or remote grid.

I.e, if you have a Selenium server set up at <http://localhost:4444> or if you have a SauceLabs / BrowserStack account.

## Variables

| Variable                  | Description                                                    | Default  | Example(s)                     |
|---------------------------|----------------------------------------------------------------|----------|--------------------------------|
| QA_BROWSER                | Browser to run against                                         | "chrome" | "chrome" "edge"                |
| QA_REMOTE_GRID_PROTOCOL   | Protocol to use                                                | "http"   | "http" "https"                 |
| QA_REMOTE_GRID            | Remote grid to run tests against                               |          | "localhost:3000" "provider:80" "selenoid:4444" |
| QA_LAYOUT                 | Used with Selenoid. Tells test nav to expect collapsed menus. "phone" expects collapsed top and left nav bars, "tablet" expects collapsed left nav bar only. |          | "phone", "tablet"              |
| SELENOID_DIRECTORY        | Used with Selenoid. Directory to save videos to                | "<host_artifacts_dir>/selenoid" |        |
| USE_SELENOID              | Used with Selenoid. Sets up selenoid containers.               | false    | false, true                    |
| QA_RECORD_VIDEO           | Used with Selenoid. Triggers video recording.                  | false    | false, true                    |
| QA_SAVE_ALL_VIDEOS        | Used with Selenoid. Saves video for both passed and failed tests | false    | false, true                    |
| QA_SELENOID_BROWSER_IMAGE | Used with Selenoid. Sets the browser image to use for video recording. | "selenoid/chrome" | "selenoid/chrome", "registry.gitlab.com/gitlab-org/gitlab-qa/selenoid-chrome-gitlab" |
| QA_SELENOID_BROWSER_VERSION | Used in conjunction with QA_SELENOID_BROWSER_IMAGE. Version of browser to run against.       | "111.0"  | "latest" "111.0" "mobile-111.0"|
| QA_VIDEO_RECORDER_IMAGE   | Used with Selenoid. Sets the video recorder image to use for video recording. | "registry.gitlab.com/gitlab-org/gitlab-qa/selenoid-manual-video-recorder" | "registry.gitlab.com/gitlab-org/gitlab-qa/selenoid-manual-video-recorder", "presidenten/selenoid-manual-video-recorder" |
| QA_VIDEO_RECORDER_VERSION | Used with Selenoid. Sets the video recorder image version to use for video recording. | "latest" | "latest"                     |
| QA_REMOTE_GRID_USERNAME   | Used with Sauce Labs. Username to specify in the remote grid. "USERNAME@provider:80" |          | "gitlab-sl"                    |
| QA_REMOTE_GRID_ACCESS_KEY | Used with Sauce Labs. Key/Token paired with `QA_REMOTE_GRID_USERNAME` |          |                                |
| QA_REMOTE_TUNNEL_ID       | Used with Sauce Labs. Name of the remote tunnel to use         | "gitlab-sl_tunnel_id" |                                |
| QA_REMOTE_MOBILE_DEVICE_NAME | Used with Sauce Labs. Name of mobile device to test against. `QA_BROWSER` must be set to `safari` for iOS devices and `chrome` for Android devices. |          | "iPhone 12 Simulator"          |

## Testing with Selenoid

Running directly against an environment like staging is not recommended because test videos can expose credentials. Therefore, it is best practice to not run against live environments. Also note that DOCKER_HOST can't be set to a non-http address.

Available browsers are defined in [browsers.json](https://gitlab.com/gitlab-org/gitlab-qa/-/blob/master/fixtures/selenoid/browsers.json)

Failure videos are available as job artifacts in the selenoid/video directory and as attachments in the Allure report.

Specs outside /browser_ui/ folder are not recorded, e.g. api specs.

### Add failure video recording to a pipeline for a non-live environment

Set these environment variables:

USE_SELENOID=true
QA_RECORD_VIDEO=true
QA_REMOTE_GRID="selenoid:4444"

#### To test with an Edge browser instead of Chrome

Include these environment variables:

QA_BROWSER="edge"
QA_SELENOID_BROWSER_IMAGE="browsers/edge"

#### To test with a Chrome mobile device browser

Include these environment variables:

QA_LAYOUT="phone"
QA_SELENOID_BROWSER_IMAGE="registry.gitlab.com/gitlab-org/gitlab-qa/selenoid-chrome-gitlab"
QA_SELENOID_BROWSER_VERSION=mobile-111.0

For now we have a limited number of images available for Chrome mobile browser testing, which can found in [gitlab-qa registry](https://gitlab.com/gitlab-org/gitlab-qa/container_registry/4079425)   

## Testing with Sauce Labs (deprecated)

Running directly against an environment like staging is not recommended because test logs expose credentials. Therefore, it is best practice and the default to use a tunnel.

To install a tunnel, follow these [instructions](https://docs.saucelabs.com/secure-connections/sauce-connect/installation). 

To start the tunnel, copy the run command in **Sauce Labs > Tunnels** and run it in the terminal. You must be logged in to Sauce Labs. Use the credentials in 1Password to log in.

It is highly recommended to use `GITLAB_QA_ACCESS_TOKEN` to speed up tests and reduce flakiness.

### Run a test in a desktop browser

While tunnel is running, to test against a local instance in a desktop browser, run:

```shell
$ QA_BROWSER="safari" \
  QA_REMOTE_GRID="ondemand.saucelabs.com:80" \
  QA_REMOTE_GRID_USERNAME="gitlab-sl" \
  QA_REMOTE_GRID_ACCESS_KEY="<access key found in Sauce Lab account>" \
  GITLAB_QA_ACCESS_TOKEN="<token>" \
  gitlab-qa Test::Instance::Any <CE|EE> http://<local_ip>:3000 -- -- <relative_spec_path>
```

### Run a test in a mobile device browser

`QA_REMOTE_MOBILE_DEVICE_NAME` can be any device name in the [supported browser devices](https://saucelabs.com/platform/supported-browsers-devices) in the Emulators/simulators list, and the latest versions of Android or iOS. You must set `QA_BROWSER` to `safari` for iOS devices and `chrome` for Android devices.```

```shell
$ QA_BROWSER="safari" \
  QA_REMOTE_MOBILE_DEVICE_NAME="iPhone 12 Simulator" \
  QA_REMOTE_GRID="ondemand.saucelabs.com:80" \
  QA_REMOTE_GRID_USERNAME="gitlab-sl" \
  QA_REMOTE_GRID_ACCESS_KEY="<found in Sauce Lab account>" \
  GITLAB_QA_ACCESS_TOKEN="<token>" \
  gitlab-qa Test::Instance::Any <CE|EE> http://<local_ip>:3000 -- -- <relative_spec_path>
```

Results can be watched in real time in Sauce Labs under AUTOMATED > Test Results
