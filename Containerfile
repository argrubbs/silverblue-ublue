ARG FEDORA_MAJOR_VERSION=37

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY ublue-firstboot /usr/bin
RUN wget https://copr.fedorainfracloud.org/coprs/calcastor/gnome-patched/repo/fedora-$(rpm -E %fedora)/calcastor-gnome-patched-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_calcastor-gnome-patched.repo
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:calcastor:gnome-patched mutter

RUN rpm-ostree override remove firefox firefox-langpacks && \
    rpm-ostree install distrobox gnome-tweaks just tailscale asusctl supergfxctl && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    systemctl enable tailscaled.service && \
    systemctl enable supergfxd.service && \
    ostree container commit
