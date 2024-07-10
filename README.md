#  nanoMDM/kmfddm Docker Examples

#### Prerequisties
- A domain which you can configure DNS on
- A dedicated host with docker running on it (or one that doesn't use ports 443/80/8080)

#### Quickstart

##### DNS Setup
For this setup, it assumes it is running on a dedicated docker host with no other apps running on ports 443, 80 or 8080.
- Set up a DNS entries on your domain for the following name which point to the public IP address of your docker host:
  - nanomdm.YOURDOMAIN.com
  - ddm.YOURDOMAIN.com

Confirm that these resolve to the IP address of your docker host before proceeding.

##### Docker Setup
- SSH into your docker host
- Clone this repo on your docker host
```bash
git clone https://github.com/macadmins/ddm_infra.git
cd ddm_infra
```
- Create the traefik network

```bash
docker network create traefik
```
- Copy `set_envs.example` to `set_envs` and set your `BASE_DOMAIN`
```bash
cp set_envs.example set_envs
# Edit export BASE_DOMAIN="mydomain.com" in set_envs.sh
```
- Copy `set_secrets.example` to `set_secrets` and follow the directions in the comment within the file
```bash
cp set_secrets.example set_secrets
# Generate your API keys and save them in set_secrets.sh
```

Also, make sure to edit `traefik/traefik.toml` and replace all YOURDOMAIN entries with your actual. This *will not work* unless your domain is set correctly in `traefik.toml`.

##### Spinning it up
For this stack to work correctly, we must spin up the services in a specific order the first time we kick them off.

- Traefik
``` bash
./compose.sh traefik up -d
# It is a good idea to check the logs and make sure nothing is erroring out before proceeding.
docker logs -f traefik
```

- Static Files Server
``` bash
./compose.sh staticfiles up -d
# Make sure there are no critical/obvious errors
docker logs -f staticfiles
```

- nanoMDM spinup
``` bash
./compose.sh nanomdm up -d
# Make sure there are no critical/obvious errors
docker logs -f nanomdm
docker logs -f kmfddm
```

Once everything looks happy, edit enroll.mobileconfig so it has your actual domain instead of `YOURDOMAIN.COM`.

After editing `enroll.mobileconfig` to match your domain, try enrolling a test node and confirm the enrollment by looking at the log files for nanomdm


----
Thanks to Digital Ocean for providing us with credits to build out this infrastucture!


<p>
  <a href="https://www.digitalocean.com/">
    <img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/PoweredByDO/DO_Powered_by_Badge_blue.svg" width="201px">
  </a>
</p>
