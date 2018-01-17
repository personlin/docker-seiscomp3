#!/usr/bin/env bash
set -e

rsync -av $SEISCOMP3_CONFIG/ $INSTALL_DIR/
rsync -av $LOCAL_CONFIG/ $HOME/.seiscomp3/
rsync -av $INIT_STATE/ $INSTALL_DIR/etc/init/

# Run lsyncd to synchronize etc/init/*.auto files in $INIT_STATE folder
cat << EOF > lsyncd.conf
sync {
    default.rsync,
    source = "$INSTALL_DIR/etc/init/",
    target = "$INIT_STATE/",
    rsync = {
        _extra = {
            "-r",
            "--include=*/",
            "--include=*.auto",
            "--exclude=*"
        }
    },
    delay=0
}
EOF

lsyncd lsyncd.conf

case $1 in
    "")
        seiscomp start
        tail -f /dev/null
    ;;
    install-deps|setup|shell|enable|disable|start|stop|restart|check|status|list|exec|update-config|alias|print|help)
        exec seiscomp "$@"
    ;;
    *)
        exec "$@"
esac