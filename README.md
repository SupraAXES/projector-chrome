# projector-chrome

**project_chrome** is an open-source projector for [**SupraRBI-VNC**](https://github.com/supraaxes/suprarbi-vnc), chrome in kiosk mode is used to open the target URL.

The image is available in public repository, and can be built from source.

> ```
> docker pull supraaxes/projector-chrome
> docker build -t projector-chrome .
> ```

For improved user experience as well as additional functionalities, commercial projector image [**projector-supra-web**](https://github.com/supraaxes/projector-supra-web) is available for business deployments, please contact info@supraaxes.com for detailed information.

## Usage
To use **projector-chrome** for [**SupraRBI-VNC**](https://github.com/supraaxes/suprarbi-vnc), please make sure the environment variable *SUPRA_PROJECTOR_IMAGE* is set to *projector-chrome* for the **SupraRBI-VNC** server.

```
docker run --name vnc-rbi -d \
    --network supra-projector \
	-p 5900:5900 \
	-e SUPRA_PROJECTOR_NETWORK='supra-projector' \
	-e SUPRA_PROJECTOR_IMAGE='supraaxes/projector-chrome' \
	-v /var/run/docker.sock:/var/run/docker.sock \
    supraaxes/suprarbi-vnc
```

## Guacamole Configuration Examples

The configuration on Apache Guacamole is straight forward as any other VNC connection, and for detailed information about session settings in *password*, please check [SupraRBI-VNC](https://github.com/supraaxes/suprarbi-vnc/README.md)

### Dynamic session to https://github.com
> *NOTE: SupraRBI-VNC server is at 192.168.0.178:5900*. <br>
>
> Name: *rbi-github*<br>
> Protocol: *VNC*<br>
> Hostname: *192.168.0.178*<br>
> Port: *5900*<br>
> Username: *https://github.com*<br>
> Password: *{}*<br>

### Shared session to https://www.google.com, with audio on
> *NOTE:*<br> 
>   *1. A shared session is for all users;* <br>
>   *2. Please ensure the guacd container is in the same network as the SupraRBI-VNC server*. <br>
><br>
> Name: *rbi-google*<br>
> Protocol: *VNC*<br>
> Hostname: *vnc-rbi*<br>
> Port: *5900*<br>
> Username: *https://www.google.com*<br>
> Password: *{"id":{"type":"norm","name":"1234"}}*<br>
> Enable audio: *checked*<br>
> Audio server name: *rbi-norm-1234*<br>