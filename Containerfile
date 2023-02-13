ARG FEDORA_MAJOR_VERSION=37

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY ublue-firstboot /usr/bin
RUN wget https://packages.microsoft.com/yumrepos/edge/microsoft-edge-beta-110.0.1587.40-1.x86_64.rpm -O /tmp/microsoft-edge-beta-110.0.1587.40-1.x86_64.rpm
RUN wget https://copr.fedorainfracloud.org/coprs/calcastor/gnome-patched/repo/fedora-$(rpm -E %fedora)/calcastor-gnome-patched-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_calcastor-gnome-patched.repo
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:calcastor:gnome-patched mutter

RUN rpm-ostree install distrobox gnome-tweaks just tailscale asusctl supergfxctl keepassxc gstreamer1-plugin-openh264 mozilla-openh264 && \
    rpm-ostree install /tmp/microsft-edge-beta-110.0.1587.40-1.x86_64.rpm && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    systemctl enable tailscaled.service && \
    systemctl enable supergfxd.service && \
    ostree container commit
