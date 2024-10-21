require xen-source.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://xenpcid-xenstore.conf \
"

PACKAGES:append = "\
    ${PN}-test \
    ${PN}-pcid \
"

FILES:${PN}-test = "\
    ${libdir}/xen/bin/test-xenstore \
    ${libdir}/xen/bin/test-resource \
    ${libdir}/xen/bin/test-paging-mempool \
"

FILES:${PN}-pcid = "\
    ${systemd_unitdir}/system/xenpcid.service \
    ${systemd_unitdir}/system/xenpcid.service.d/xenpcid-xenstore.conf \
"

FILES:${PN}:append = "\
  ${libdir}/xen/bin/init-dom0less \
  ${libdir}/xen/bin/xen-9pfsd \
"

FILES:${PN}-xencommons:remove = " ${systemd_unitdir}/system/var-lib-xenstored.mount"
SYSTEMD_SERVICE:${PN}-xencommons:remove = " var-lib-xenstored.mount "

# Remove the recommendation for Qemu for non-hvm x86 added in meta-virtualization layer
RRECOMMENDS:${PN}:remove = "qemu"

# Avoid redundant runtime dependency on python3-core
RDEPENDS:${PN}:remove:class-target = "${PYTHON_PN}-core"

DEPENDS:remove = "pixman virtual/libsdl"

SYSTEMD_SERVICE:${PN}-pcid = "xenpcid.service"

SYSTEMD_PACKAGES += "${PN}-pcid"

do_install:append() {
    rmdir ${D}/var/lib
    rmdir ${D}/var
    install -d ${D}${systemd_unitdir}/system/xenpcid.service.d/
    install -m 0744 ${WORKDIR}/xenpcid-xenstore.conf ${D}${systemd_unitdir}/system/xenpcid.service.d
}
