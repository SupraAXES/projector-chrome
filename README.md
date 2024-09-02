# projector-chrome

**project_chrome** is an open-source projector for [**SupraRBI-VNC**](https://github.com/supraaxes/suprarbi-vnc), chrome in kiosk mode is used to open the target URL.

The image is available in public repository, and can be built from source.

> ```
> docker pull supraaxes/projector-chrome
> docker build -t projector-chrome .
> ```

## Usage
To use **projector-chrome** for [**SupraRBI-VNC**](https://github.com/supraaxes/suprarbi-vnc), please make sure the environment variable *SUPRA_PROJECTOR_IMAGE* is set to *projector-chrome* for the **SupraRBI-VNC** server.

```
docker run --name rbi-vnc -d \
    --network supra-projector \
	-p 5900:5900 \
	-e SUPRA_RBI_NAME='rbi-vnc' \
	-e SUPRA_PROJECTOR_NETWORK='supra-projector' \
	-e SUPRA_PROJECTOR_IMAGE='supraaxes/projector-chrome' \
	-v /var/run/docker.sock:/var/run/docker.sock \
	vnc_rbi
```