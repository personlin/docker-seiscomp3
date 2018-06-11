#!/usr/bin/env bash
set -e

# Copy local files
rsync -av $SEISCOMP3_CONFIG/ $INSTALL_DIR/
rsync -av $LOCAL_CONFIG/ /home/sysop/.seiscomp3/
rsync -av $INIT_STATE/ $INSTALL_DIR/etc/init/

# Give right to user sysop
chown -R sysop:sysop $INSTALL_DIR
chown -R sysop:sysop /home/sysop/.seiscomp3
chown -R sysop:sysop $INIT_STATE

# Execute init scripts
for f in /docker-entrypoint-init.d/*; do
    echo "$0: running $f"; . "$f"
done

# Start seiscomp
case $1 in
    "")
        supervisord -c supervisord.conf
    ;;
    install-deps|setup|shell|enable|disable|start|stop|restart|check|status|list|exec|update-config|alias|print|help)
        exec gosu sysop seiscomp "$@"
    ;;
    *)
        exec "$@"
esac
